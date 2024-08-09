# == Schema Information
#
# Table name: user_event_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserEventType < ApplicationRecord

  def self.values
    [
      :signup,
      :update_language,
      :update_condition_area,
      :unsubscribe,
      :acknowledge_edd,
      :acknowledge_dob,
      :change_campaign
    ]
  end
end
