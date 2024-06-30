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
      :signup_attempt,
      :change_language,
      :change_condition_area,
      :unsubscribe
    ]
  end
end
