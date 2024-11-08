# this class parses the webhook params that come in from Turn.

require_relative '../../../lib/utils.rb'
require_relative '../../exceptions/http.rb'

module Alerts

  FIVE_DAYS = 5 * 24 * 60 * 60

  class CreateAlert < MessageEvents::Base

    def initialize(logger, phone, ticket_id, symptom, alert_identified_at)
      super(logger)

      @user = User.find_by_phone(phone)
      unless @user.can_create_alert
        raise Forbidden.new("User doesn't qualify for alert creation")
      end

      @ticket_id = ticket_id
      @alert_identified_at = parse_timestamp(alert_identified_at)
      @symptom = symptom
      @nhub = Nhub::Nhub.new(self.logger, ENV["NHUB_URL"], ENV["NHUB_API_KEY"])
    end

    def call
      alert = HealthAlert
                .left_outer_joins(notifications: :responses)
                .where(
                  responses: { id: nil },
                  user_id: @user.id,
                )
                .order(created_at: :desc)
                .first

      # TODO: create notification
      if not alert.nil? and alert.ticket_id == @ticket_id
        if alert.symptom == @symptom
          raise DuplicateResource.new("HealthAlert already exists")
        else
          raise DuplicateResource.new("HealthAlert already exists with different symptom")
        end
      end

      new_alert = HealthAlert.new(
        user_id: @user.id,
        ticket_id: @ticket_id,
        symptom: @symptom,
        alert_identified_at: @alert_identified_at,
      )
      unless new_alert.save
        raise MultipleErrors("Unable to create object", alert.errors.full_messages)
      end

      # Send the most recent alert_id to all other platforms
      @nhub.update_user_attribute(
        phone: @user.mobile_number,
        attribute: "alert_id",
        value: new_alert.id,
      )

      if alert.nil? or (alert.ticket_id != @ticket_id and alert.alert_identified_at < Time.now - FIVE_DAYS)
        # textit campaign starts only when alert_identified_at is set
        # TODO: asha, anm (not mo) follow up campaign should start from most recent alert
        @nhub.update_user_attribute(
          phone: @user.mobile_number,
          attribute: "alert_identified_at",
          value: @alert_identified_at,
        )
      end

      # start sending messages to all stakeholders
      templates = YAML.load(File.read("config/turn_api_config.yml"))
      # send message to HRPW
      op = TurnApi::SendAlertMessage.(user_id: @user.id, template_name: templates[:hrpw_alert])
      if op.errors.present?
        self.errors << "Could not send message to HRPW: #{op.errors}"
      else
        # add healthalert notification object
        alert.notifications.build(user: @user,
                                  platform: "whatsapp",
                                  event_timestamp: DateTime.now)
      end

      # send message to ASHA. First retrieve respective ASHA and ANM objects
      @asha = @user.rch_profile.asha
      op = TurnApi::SendAlertMessage.(user_id: @asha.id, template_name: templates[:asha_alert])
      if op.errors.present?
        self.errors << "Could not send message to ASHA: #{op.errors}"
      else
        # add healthalert notification object
        alert.notifications.build(user: @asha,
                                  platform: "whatsapp",
                                  event_timestamp: DateTime.now)
      end

      @anm = @user.rch_profiles.anm
      op = TurnApi::SendAlertMessage.(user_id: @anm.id, template_name: templates[:anm_alert])
      if op.errors.present?
        self.errors << "Could not send message to HRPW: #{op.errors}"
      else
        # add healthalert notification object
        alert.notifications.build(user: @anm,
                                  platform: "whatsapp",
                                  event_timestamp: DateTime.now)
      end

      return {
               status: "created a new HealthAlert",
               alert_id: new_alert.id,
               symptom: new_alert.symptom,
             }
    end
  end


  private



end
