# frozen_string_literal: true

# == Schema Information
#
# Table name: asha_users
#
#  id            :bigint           not null, primary key
#  mobile_number :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  district_id   :bigint           not null
#  state_id      :bigint           not null
#
# Indexes
#
#  index_asha_users_on_district_id  (district_id)
#  index_asha_users_on_state_id     (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (district_id => districts.id)
#  fk_rails_...  (state_id => states.id)
#
class AshaUser < ApplicationRecord

end
