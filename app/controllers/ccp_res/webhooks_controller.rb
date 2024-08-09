# frozen_string_literal: true

# this controller contains the actions for all the webhook-based events that are triggered for a particular user
class WebhooksController < ApplicationController

  before_action :initiate_logger

  # this action accepts a webhook from Textit whenever there's a group change (i.e. campaign change) for a user
  # and records that as an event in the UserTextitGroupMapping table, along with creating an event recording campaign change
  # Params format:
  # {
  #   "mobile_number"=>["whatsapp:91XXXXXXX", "tel:+91XXXXXX"] # this will basically be the URNs column
  #   "group_name": "",
  #   "channel": "" # textit, turn etc.
  #   "group_textit_id": "Textit ID of the group that the user has joined"
  # }
  def update_user_campaign
    op = UserEvents::UpdateCampaign.(logger, textit_params)
    if op.errors.present?
      logger.warn("Campaign update failed with the errors: #{op.errors.to_sentence}")
      render status: 400, json: {success: false, errors: op.errors}
    else
      render json: {success: true}
    end
  end


  # this action updates  a user's details from Textit's webhook
  # It can be things like EDD, DOB, condition area, gender etc.
  # Params format:
  # {
  #   "mobile_number"=>["whatsapp:91XXXXXXX", "tel:+91XXXXXX"] # this will basically be the URNs column
  #   "attribute": <edd, dob, gender etc.>
  #   "value": <value of the attribute>
  # }
  def update_user_attribute

  end

  private

  def textit_params
    params.permit!
  end

  def initiate_logger
    self.logger = Logger.new("#{Rails.root}/log/ccp_res/webhooks/#{action_name}.log")
    self.logger.info("-------------------------------------")
    logger.info("API parameters are: #{params.permit!}")
  end

end
