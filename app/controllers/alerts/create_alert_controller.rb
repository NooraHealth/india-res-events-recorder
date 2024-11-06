# frozen_string_literal: true

require_relative '../../exceptions/http.rb'

class Alerts::CreateAlertController < ApplicationController
  before_action :initiate_logger

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/alerts/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{params.permit!}")
  end

  def create_alert
    begin
      phone, ticket_id, symptom, alert_identified_at = params.require(
        [:phone, :ticket_id, :symptom, :alert_identified_at]
      )
    rescue ActionController::ParameterMissing => exception
      self.logger.warn(exception.message)
      return render json: {
               success: false,
               errors: [exception.message],
             },
             status: 400
    end

    begin
      op = Alerts::CreateAlert.(
        self.logger,
        phone,
        ticket_id,
        symptom,
        alert_identified_at,
      )
      return render json: {
               success: true,
               data: {
                 # TODO: add data
               }
             },
             status: :created


    rescue ActiveRecord::RecordInvalid => exception
      self.logger.warn(exception.record.errors.full_messages)
      return render json: {
               success: false,
               errors: exception.record.errors.full_messages,
             },
             status: :unprocessable_entity

    rescue HttpError => exception
      self.logger.warn("#{exception.status}: #{exception.message}")
      return render json: {
               success: false,
               errors: [exception.message]
             },
             status: exception.status
    end

  end
end
