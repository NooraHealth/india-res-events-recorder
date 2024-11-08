# this class will accept responses from healthcare workers for a particular patient
# and record them as responses in the health_alert_responses table
# This will come from within the journey on Turn

require_relative '../../../lib/utils.rb'
require_relative '../../exceptions/http.rb'

module Alerts
  class HcwConfirmCare < MessageEvents::Base

    def initialize(logger, turn_params)
      super(logger)
      @hcw_type = turn_params[:hcw_type]
      @phone = turn_params[:phone]
      @patient_phone = turn_params[:patient_phone]
    end

    def call
      if @hcw_type == "AnmUser"
        hcw_user = AnmUser.find_by_phone(@phone)
      elsif @hcw_type == "AshaUser"
        hcw_user = AshaUser.find_by_phone(@phone)
      else
        raise BadRequest.new("hcw_type can be one of AnmUser/AshaUser")
      end

      user_ids = hcw_user.get_patient_profiles.map { |x| x.user.id }
      if user_ids.length == 0
        raise Forbidden.new("Hcw doesn't qualify for confirming care")
      end

      @patient_user = User.find_by_phone(@patient_phone)
      unless user_ids.include? @patient_user.id
        raise Forbidden.new("Asha is not allowed to confirm care for this user")
      end

      notification = hcw_user.get_most_recent_health_alert_notification(@patient_user.id)

      if notification.blank?
        self.errors << "No health alert notification found for user with mobile number: #{@patient_phone}"
        return self
      end

      # create a health_alert_response object for this notification
      response = HealthAlertResponse.new(user: @patient_user,
                                         health_alert_id: notification.health_alert_id,
                                         health_alert_notification_id: notification.id,
                                         platform: "turn")
      unless response.save
        self.errors << "Could not save health alert response because: #{response.errors.full_messages}"
        return self
      end

      self
    end

  end
end
