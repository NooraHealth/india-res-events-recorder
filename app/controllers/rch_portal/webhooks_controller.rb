# frozen_string_literal: true

class WebhooksController < ApplicationController


  # the below action updates the user_event_tracker table with details about the IVR call and
  # the respective user for whom this was triggered
  def update_ivr_onboarding_attempts
    # call operation to update user event tracker and also potentially the user_textit_groups mapping if needed

  end

  def acknowledge_direct_whatsapp_signup

  end

  private

  def exotel_params
    params.permit!
  end


end
