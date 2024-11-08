# this operation accepts a single ID or a list of IDs and updates the WhatsApp ID of that particular user in our database
############################################################################
# ################### NOT BEING USED CURRENTLY #############################
# ############################################################################


module TurnApi
  class UpdateWhatsappId < ApplicationService

    include Sidekiq::Worker

    attr_accessor :users

    def perform(user_ids)
      self.users = User.where(id: user_ids)
      self.call
    end


    def call
      # initiate logger to log details of API call
      logger = Logger.new("#{Rails.root}/log/turn_api/update_whatsapp_id.log")

      op = TurnApi::RetrieveWhatsappId.(logger, self.users)
      if op.errors.present?
        logger.warn("WhatsApp ID retrieval returned errors: #{op.errors}")
      end
    end

  end
end
