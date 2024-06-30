# == Schema Information
#
# Table name: districts
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :bigint
#
# Indexes
#
#  index_districts_on_state_id  (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (state_id => states.id)
#
class District < ApplicationRecord
  belongs_to :state
end
