# frozen_string_literal: true

# This operation takes a message that needs to be sent to a user
# Sample Success response:
# {
#     "messages": [
#         {
#             "id": "wamid.HBgMOTE4MTA1NzM5Njg0FQIAERgSNDhEMUQzNzg2MDREOUE4NDdCAA==" # this is the message ID
#         }
#     ],
#     "meta": {
#         "version": "4.602.0",
#         "backend": {
#             "name": "WhatsApp",
#             "version": "latest"
#         },
#         "api_status": "stable"
#     }
# }

# Sample error response:
# {
#     "meta": {
#         "version": "4.602.0",
#         "backend": {
#             "name": "WhatsApp",
#             "version": "latest"
#         },
#         "api_status": "stable"
#     },
#     "errors": [
#         {
#             "code": 131026,
#             "fbtrace_id": "AWyuPqa-jZGicZsPBX7wvPk",
#             "message": "(#131026) Message undeliverable",
#             "type": "OAuthException"
#         }
#     ]
# }

# Input parameters:
# {
#  user_id: <ID of the user to send the message to>,
#  template_name: <Name of the template to send to the user>
# }
#


module TurnApi
  class SendAlertMessage < TurnApi::Base

    attr_accessor :user_id, :user, :template_name, :placeholder_values

    def initialize(logger, params)
      super(logger)
      self.user_id = params[:user_id]
      self.template_name = params[:template_name]
      self.placeholder_values = params[:placeholder_values]
    end

    def call
      # first setup the connection and initialize network call variables
      setup_connection

      # check if the user is there in the database
      self.user = User.find_by id: self.user_id
      if self.user.blank?
        self.errors << "User not found in database with ID: #{self.user_id}"
        return self
      end

      # check if the message content is present, if not throw an error
      if self.template_name.blank?
        self.errors << "Template name cannot be blank"
        return self
      end

      # now send the message to the user by calling the API
      execute_api_call

      # now check for success and failure errors and update the user's flag accordingly
      # if the message has been sent successfully

      if self.response.status == 200
        self.parsed_response = JSON.parse(self.response.body)
        # now check for the messages key in the response
        if self.parsed_response["messages"].present?
          # this means user is present on WhatsApp
          self.logger.info("Successfully sent a message to user with mobile number: #{self.user.whatsapp_id}. Response: #{self.parsed_response}")
          self.user.update(present_on_whatsapp: true)
        end
      elsif self.response.status == 400
        self.parsed_response = JSON.parse(self.response.body)
        # in this case the user is not present on WhatsApp, because the response is a 400
        self.logger.error("User with mobile number: #{self.user.mobile_number} is not present on WhatsApp. Response: #{self.parsed_response} and Error code: #{self.parsed_response["errors"][0]["code"]}")
        self.errors << "User not on WhatsApp, Response: #{self.parsed_response} and Error code: #{self.parsed_response["errors"][0]["code"]}"
        self.user.update(present_on_whatsapp: false, whatsapp_id: nil)
      else
        self.parsed_response = JSON.parse(self.response.body)
        self.logger.error("Message not sent successfully. Status: #{self.response.status}, Response: #{self.parsed_response}")
        self.errors << "Message not sent successfully. Status: #{self.response.status}, Error: #{self.parsed_response}"
      end

      self

    end

    protected

    def action_path
      'messages'
    end

    def api_method
      :post
    end

    # these are the expected parameters for the request to send a message to a user
    def body_params
      {
        "to": self.user.whatsapp_id,
        "type":"template",
        "template":
          {
            "namespace": self.turn_configs[:namespace],
            "name": self.templates[self.template_name],
            "language":
              {
                "policy":"deterministic",
                "code": self.user.language.two_letter_code
              }
          },
        "components": [
          {
            "type": "body",
            "parameters": format_parameters(self.placeholder_values)
          }
        ]
      }
    end

    def format_parameters(placeholder_values)
      parameters_request_format = []
      placeholder_values.keys.each do |key|
        parameters_request_format << {
          "type": "text",
          text: placeholder_values[key]
        }
      end
      parameters_request_format
    end

  end
end
