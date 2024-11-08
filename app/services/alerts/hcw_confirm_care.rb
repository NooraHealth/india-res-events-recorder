# this class will accept responses from healthcare workers for a particular patient
# and record them as responses in the health_alert_responses table
# This will come from within the journey on Turn

require_relative '../../../lib/utils.rb'
require_relative '../../exceptions/http.rb'

module Alerts
  class HcwConfirmCare < MessageEvents::Base

    def initialize(logger, hcw_type, phone, patient_phone, platform)
      super(logger)
      if hcw_type == "AnmUser"
        hcw_user = AnmUser.find_by_phone(phone)
        @user_type = HealthAlertResponse::ANM_TYPE
      elsif hcw_type == "AshaUser"
        hcw_user = AshaUser.find_by_phone(phone)
        @user_type = HealthAlertResponse::ASHA_TYPE
      else
        raise BadRequest.new("hcw_type can be one of AnmUser/AshaUser")
      end
      user_ids = hcw_user.get_patient_profiles.map { |x| x.user.id }
      if user_ids.length == 0
        raise Forbidden.new("Hcw doesn't qualify for confirming care")
      end

      @patient_user = User.find_by_phone(patient_phone)
      @platform = platform

      unless user_ids.include? @patient_user.id
        raise Forbidden.new("Asha is not allowed to confirm care for this user")
      end

      @notification = hcw_user.get_most_recent_health_alert_notification(@patient_user.id)

      if @notification.blank?
        raise RecordNotFound.new("No health alert notification found")
      end

      # TODO: responses filter for NO when we implement it
      if @notification.responses.length > 0
        raise UnprocessableEntity.new("Response already recorded")
      end

    end


    def confirm
      # create a health_alert_response object for this notification
      response = HealthAlertResponse.new(user_id: @patient_user.id,
                                         user_type: @user_type,
                                         health_alert_id: @notification.health_alert_id,
                                         health_alert_notification_id: @notification.id,
                                         response: "YES", # TODO: response
                                         platform: @platform)
      unless response.save
        raise MultipleErrors.new("Unable to create response object", response.errors.full_messages)
      end

      return "success"
    end

  end
end
