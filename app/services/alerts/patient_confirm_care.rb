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
      

    end
  end
end
