# frozen_string_literal: true

module Alerts
  class AlertsController < ApplicationController

    # this action initiates the alert to all stakeholders
    def create
      creator = Alerts::CreateAlert.new(
        self.logger,
        *params.require(
          [
            :phone,
            :ticket_id,
            :symptom,
            :alert_identified_at
          ]
        )
      )

      return render json: {
        success: true,
        data: creator.create_alert,
      },
                    status: :created
    end


    # this action returns the list of active alerts for a HCW
    def hcw_active_alerts
      listmaker = Alerts::HcwListAlertedUsers.new(
        self.logger,
        *params.require(
          [:phone, :serial_number,]
        )
      )

      return render json: {
        success: true,
        data: listmaker.list_alerted_users,
      },
                    status: 200
    end

    # this action confirms care from a patient
    def patient_confirm_care
      responder = Alerts::HcwPatientCare.new(
        self.logger,
        *params.require(
          [:hcw_type, :phone, :patient_phone, :platform,]
        )
      )

      return render json: {
        success: true,
        data: responder.call,
      },
                    status: 200
    end

    # this action confirms care from a healthcare worker
    def hcw_confirm_care
      responder = Alerts::HcwConfirmCare.new(
        self.logger,
        *params.require(
          [:hcw_type, :phone, :patient_phone, :platform,]
        )
      )

      return render json: {
        success: true,
        data: responder.confirm,
      },
                    status: 200
    end

  end
end
