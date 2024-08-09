# this class will accept attributes of a user that gets updated in different platforms
# In general, if this happens in textit, the params will be as follows:
# Params format:
# {
#   "mobile_number"=>["whatsapp:91XXXXXXX", "tel:+91XXXXXX"] # this will basically be the URNs column
#   "attribute": <edd, dob, gender etc.>
#   "value": <value of the attribute>,
#   "platform": "textit"
# }

module UserEvents
  class UpdateAttribute < CampaignEvents::Base

    attr_accessor :attribute_params

    def initialize(logger, params)
      super(logger)
      self.attribute_params = params
    end

    def call

    end

  end
end
