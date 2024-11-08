# frozen_string_literal: true
# this operation will acknowledge care by the patient themselves
# They can either confirm care on their primary number or their alternate number
# {
#   urns: ["tel:1234567890", whatsapp:12345678]
# }

module Alerts
  class PatientConfirmCare < Alerts::Base

    attr_accessor :textit_params

    def initialize(logger, params)
      super(logger)
      self.textit_params = params
    end

    def call

      mobile_number = extract_mobile_number("textit", textit_params[:urns])
      # look for user and find their latest health_alert_notification
      @res_user = User.find_by mobile_number: mobile_number

      if @res_user.blank?
        self.errors << "User not found in database with mobile number: #{mobile_number}"
        return self
      end

      # find the latest health alert notification for this user
      notification = @res_user.get_most_recent_health_alert_notification
      if notification.blank?
        self.errors << "No health alert notification found for user with mobile number: #{mobile_number}"
        return self
      end

      # create a health_alert_response object for this notification
      response = HealthAlertResponse.new(user: @res_user,
                                         health_alert_id: notification.health_alert_id,
                                         health_alert_notification_id: notification.id,
                                         platform: "textit")
      unless response.save
        self.errors << "Could not save health alert response because: #{response.errors.full_messages}"
        return self
      end

      # TODO - create event to signify health alert being resolved

      self
    end
  end
end
