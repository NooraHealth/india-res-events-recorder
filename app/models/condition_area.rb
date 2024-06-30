# == Schema Information
#
# Table name: condition_areas
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ConditionArea < ApplicationRecord

  def self.values
    [
      :anc,
      :pnc,
      :sncu,
      :inpatient_non_surgery,
      :cardiology_pre_selection,
      :cardiology,
      :cardiology_pre_surgery,
      :cardiology_post_surgery,
      :gems_neutral,
      :diabetes,
      :hypertension,
      :mch_neutral,
      :ncd_neutral,
      :anc_edd,
      :pnc_dob
    ]
  end

  has_many :user_condition_area_mappings
  has_many :users, through: :user_condition_area_mappings

  # def self.retrieve_condition_area_from_number(number)
  #   ca = ConditionAreaNumberMapping.with_exotel_number(number).first
  #   return ca&.condition_area_id
  # end

  def anc?
    self.name == "anc"
  end

  def pnc?
    self.name == "pnc"
  end

end
