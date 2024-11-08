# frozen_string_literal: true
# this operation will acknowledge care by the patient themselves
# They can either confirm care on their primary number or their alternate number
# {
#   urns: ["tel:1234567890", whatsapp:12345678]
# }

module Alerts
  class PatientConfirmCare < Alerts::Base

    attr_accessor :textit_params

    def initialize(logger, phone, platform)
      super(logger)
      @phone = phone
      @platform = platform
    end

    def confirm

      # mobile_number = extract_mobile_number("textit", textit_params[:urns])
      # look for user and find their latest health_alert_notification
      res_user = User.find_by_phone(@phone)

      # find the latest health alert notification for this user
      notification = res_user.get_most_recent_health_alert_notification
      if notification.blank?
        raise RecordNotFound.new("No health alert notification found")
      end

      # TODO: responses filter for NO when we implement it
      if notification.responses.length > 0
        raise UnprocessableEntity.new("Response already recorded")
      end

      # create a health_alert_response object for this notification
      response = HealthAlertResponse.new(user_id: res_user.id,
                                         user_type: HealthAlertResponse::PATIENT_TYPE,
                                         health_alert_id: notification.health_alert_id,
                                         health_alert_notification_id: notification.id,
                                         platform: @platform)
      unless response.save
        raise MultipleErrors("Unable to create response object", response.errors.full_messages)
      end

      # TODO - create event to signify health alert being resolved

      return "success"
    end
  end
end
