# this class fetches the Whatsapp ID of the user using Turn's APIs and updates it in the local database
# APi used: https://whatsapp.turn.io/docs/api/contacts
# It accepts collection of users, whose international mobile numbers are extracted
# and then sent in bulk to the contacts API to check if a user is available on WA or not
# Accepts a maximum of 100 users at once - if the number of users is more it returns an error

# the object returned has an array of numbers with their respective whatsapp IDs in a collection called `contacts`

module TurnApi
  class RetrieveWhatsappId < TurnApi::Base

    attr_accessor :users, :contacts_list, :contacts

    def initialize(logger, params)
      super(logger)
      self.users = params
      self.contacts_list = []
    end

    def call
      # first setup connection and initialize network call variables
      setup_connection

      # if the list of users is empty, return with an error
      if self.users.count == 0
        self.errors << "No users to check for"
        return self
      end

      # validate if the size of the array is more than 100

      if self.users.count > 500
        self.errors << "Number of users to check is more than 500"
        return self
      end

      # check to make sure all numbers are in proper international format
      self.users.each do |user|
        # if it's properly formatted with 0 followed by 10 digit number
        self.contacts_list << user.international_mobile_number
      end

      execute_api_call

      # now parse the response and extract the whatsapp id for each if it's a 200
      # if there is a WhatsApp ID then update the user's whatsapp_id column with this information
      if self.response.status == 200
        self.parsed_response = JSON.parse(self.response.body)
        self.contacts = self.parsed_response["contacts"]
        self.contacts.each do |contact|
          if contact["status"] == "valid"
            wa_id = contact["wa_id"]
            number = "0#{contact["input"][3..(contact["input"].length)]}"
            user = User.find_by mobile_number: number
            user&.update(whatsapp_id: wa_id) if user&.whatsapp_id.blank?
          end
        end
      else
        # for now, do nothing. TODO
      end

      self

    end

    private

    def action_path
      'contacts'
    end

    def api_method
      :post
    end

    def body_params
      {
        "blocking": "wait",
        "contacts": self.contacts_list
      }
    end

  end
end