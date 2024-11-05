# this class will update the TextitGroup-User mapping based on user's movement
# in Textit. The parameters will be sent from Textit's webhook which updates
# the mapping on our database.
# Parameters:
# # {
# #   "mobile_number"=>["whatsapp:91XXXXXXX", "tel:+91XXXXXX"] # this will basically be the URNs column
# #   "group_name": "",
# #   "channel": "" # textit, turn etc.
# #   "group_textit_id": "Textit ID of the group that the user has joined"
# # }

module UserEvents
  class UpdateCampaign < CampaignEvents::Base

    attr_accessor :campaign_update_params, :user, :textit_group

    def initialize(logger, params)
      super(logger)
      self.campaign_update_params = params
    end

    def call
      # first look for the user from the params
      channel = self.campaign_update_params[:channel]
      mobile_number = extract_mobile_number(channel, self.campaign_update_params)
      if mobile_number.blank?
        self.errors << "Mobile number not found in params, or not formatted correctly"
        return self
      end

      # extract the textit group based on params and raise error if the `group_textit_id` field
      # does not contain valid textit group details
      textit_group_id = self.campaign_update_params[:group_textit_id]
      self.textit_group = TextitGroup.find_by(textit_id: textit_group_id)
      if self.textit_group.blank?
        self.errors << "Textit group not found in database with textit_id: #{textit_group_id}"
        return self
      end

      # look for the user using the mobile number
      # if the user is not found, raise an error and return
      self.user = User.find_by(mobile_number: mobile_number)
      if self.user.blank?
        self.errors << "User not found in database with mobile number: #{mobile_number}"
        return self
      end

      # add an event recording change in condition area here. For this we will use the
      # condition area of the Textit group and add that as an event
      condition_area_id = self.textit_group.condition_area_id
      # associate the condition area with the user
      self.user.add_condition_area(self.textit_group.noora_program_id, condition_area_id)
      # create an event recording this condition area update
      event = self.user.user_event_trackers.build(
        noora_program_id: self.textit_group.noora_program_id,
        language_id: self.user.language_preference_id,
        platform: "textit",
        state_id: self.textit_group.state_id,
        condition_area_id: condition_area_id,
        event_timestamp: DateTime.now,
        event_type_id: UserEventType.id_for(:change_campaign)
      )

      unless event.save
        self.errors << "Event could not be created for campaign change: #{self.campaign_update_params} because: #{event.errors.full_messages}"
        return self
      end

      # create an object of UserTextitGroupMapping and save it
      # if the object is not saved, raise an error and return
      user_textit_group_mapping = UserTextitGroupMapping.new(
        user_id: self.user.id,
        textit_group_id: self.textit_group.id,
        event_timestamp: DateTime.now,
        user_event_tracker_id: event.id
      )
      if user_textit_group_mapping.save
        self.errors = user_textit_group_mapping.errors.full_messages
        return self
      end

      self

    end
  end
end
