require_relative '../exceptions/http.rb'

class ApplicationController < ActionController::API

  attr_accessor :logger

  before_action :initiate_logger

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActionController::RoutingError, with: :handle_routing_error
  rescue_from ActionController::ParameterMissing, with: :handle_invalid_parameter
  rescue_from HttpError, with: :handle_http_error
  rescue_from MultipleErrors, with: :handle_multiple_errors

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/alerts/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{params.permit!}")
  end

  def handle_multiple_errors(exception)
    self.logger.warn("#{exception.status}: #{exception.errors}")
    return render json: {
                    success: false,
                    errors: [exception.message] + exception.errors,
                  },
                  status: exception.status
  end

  def handle_http_error(exception)
    self.logger.warn("#{exception.status}: #{exception.message}")
    return render json: {
                    success: false,
                    errors: [exception.message]
                  },
                  status: exception.status
  end

  def handle_invalid_parameter(exception)
    self.logger.warn(exception.message)
    return render json: {
                    success: false,
                    errors: [exception.message],
                  },
                  status: 400
  end

  def handle_record_invalid(exception)
    self.logger.warn(exception.record.errors.full_messages)
    return render json: {
                    success: false,
                    errors: exception.record.errors.full_messages,
                  },
                  status: :unprocessable_entity

  end

  def handle_record_not_found(exception)
    self.logger.warn(exception.message)
    return render json: {
                    success: false,
                    errors: [exception.message],
                  },
                  status: :not_found

  end

end
