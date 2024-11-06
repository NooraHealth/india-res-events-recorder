# frozen_string_literal: true


class Alerts::CreateAlertController < ApplicationController

  def create_alert
    phone, ticket_id, symptom, alert_identified_at = params.require(
      [:phone, :ticket_id, :symptom, :alert_identified_at]
    )

    creator = Alerts::CreateAlert.new(
      self.logger,
      phone,
      ticket_id,
      symptom,
      alert_identified_at,
    )

    return render json: {
                    success: true,
                    data: creator.create_alert,
                  },
                  status: :created


  end
end
