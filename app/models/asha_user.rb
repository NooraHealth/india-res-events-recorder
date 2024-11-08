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

require_relative '../../lib/utils.rb'


class AshaUser < ApplicationRecord

  belongs_to :district

  has_many :rch_profiles, dependent: :destroy

  def self.find_by_phone(phone)
    return find_user_by_phone(AshaUser, phone, :in)
  end

  def get_patient_profiles
    district = self.district.name
    self.rch_profiles.includes(user: :state).select do |profile|
      profile.user.can_create_alert and profile.district == district
    end
  end

end
