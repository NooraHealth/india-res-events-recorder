# frozen_string_literal: true


class Alerts::CreateAlertController < ApplicationController
  before_action :initiate_logger

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/alerts/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{params.permit!}")
  end

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
