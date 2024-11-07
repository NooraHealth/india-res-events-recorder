# == Schema Information
#
# Table name: rch_profiles
#
#  id                  :bigint           not null, primary key
#  address             :string
#  anm_contact         :string
#  anm_name            :text
#  asha_contact        :string
#  asha_name           :string
#  blood_group         :string
#  case_no             :integer
#  district            :string
#  health_block        :text
#  health_facility     :text
#  health_sub_facility :text
#  high_risk_details   :text
#  high_risk_pregnancy :boolean          default(FALSE)
#  husband_name        :string
#  med_past_illness    :string
#  mobile_of           :string
#  mother_age          :integer
#  name                :string
#  rch_visit_1_date    :datetime
#  rch_visit_2_date    :datetime
#  rch_visit_3_date    :datetime
#  rch_visit_4_date    :datetime
#  rch_visit_5_date    :datetime
#  rch_visit_6_date    :datetime
#  rch_visit_7_date    :datetime
#  rch_visit_8_date    :datetime
#  registration_date   :datetime
#  village             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  rch_id              :string
#  user_id             :bigint
#
# Indexes
#
#  index_rch_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class RchProfile < ApplicationRecord
  belongs_to :user
  belongs_to :asha_user
  belongs_to :anm_user

  validates :rch_id, presence: true, uniqueness: true
end
