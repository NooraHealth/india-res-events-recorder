# frozen_string_literal: true

module CampaignEvents
  class Base < ApplicationService
    attr_accessor :logger

    def initialize(logger)
      self.logger = logger
    end

    protected

    # this method extracts the mobile number of the user based on where requests are coming from
    # For ex. if it's from TextIt, it will be based on the urns attribute etc.
    def extract_mobile_number(channel, params)
      case channel
      when "textit"
        # the data is sent like so:
        # "mobile_number"=>["whatsapp:918105739684", "tel:+918105739684"]
        params["mobile_number"].each do |urn|
          if urn.include?("tel")
            return "0#{urn.chars.last(10).join}"
          end
        end
      else
        ""
      end
      ""
    end
  end
end
