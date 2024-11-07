# == Schema Information
#
# Table name: users
#
#  id                             :bigint           not null, primary key
#  baby_date_of_birth             :datetime
#  calculated_onboarding_attempts :integer
#  date_of_discharge              :datetime
#  expected_date_of_delivery      :datetime
#  incoming_call_date             :datetime
#  ivr_unsubscribe_date           :datetime
#  language_selected              :boolean          default(FALSE)
#  last_menstrual_period          :datetime
#  mobile_number                  :string
#  name                           :string
#  onboarding_attempts            :integer          default(0)
#  present_on_wa                  :boolean          default(FALSE)
#  qr_scan_date                   :datetime
#  registered_on_whatsapp         :boolean          default(TRUE)
#  signed_up_to_ivr               :boolean          default(FALSE)
#  signed_up_to_whatsapp          :boolean          default(FALSE)
#  tb_diagnosis_date              :datetime
#  tb_treatment_start_date        :datetime
#  textit_uuid                    :string
#  whatsapp_mobile_number         :string
#  whatsapp_number_confirmed      :boolean          default(FALSE)
#  whatsapp_onboarding_date       :datetime
#  whatsapp_unsubscribe_date      :datetime
#  whatsapp_unsubscribed_date     :datetime
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  condition_area_id              :integer
#  hospital_id                    :integer
#  language_preference_id         :integer
#  onboarding_method_id           :bigint
#  program_id                     :integer
#  reference_user_id              :integer
#  state_id                       :integer
#  states_id                      :bigint
#  whatsapp_id                    :string
#
# Indexes
#
#  index_users_on_condition_area_id       (condition_area_id)
#  index_users_on_language_preference_id  (language_preference_id)
#  index_users_on_mobile_number           (mobile_number)
#  index_users_on_onboarding_method_id    (onboarding_method_id)
#  index_users_on_program_id              (program_id)
#  index_users_on_states_id               (states_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_area_id => condition_areas.id)
#  fk_rails_...  (hospital_id => hospitals.id)
#  fk_rails_...  (language_preference_id => languages.id)
#  fk_rails_...  (onboarding_method_id => onboarding_methods.id)
#  fk_rails_...  (program_id => noora_programs.id)
#  fk_rails_...  (state_id => states.id)
#
require_relative '../exceptions/http.rb'
require_relative '../../lib/utils.rb'

class User < ApplicationRecord

  validates :mobile_number, presence: true, uniqueness: true

  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :condition_area, optional: true
  belongs_to :language_preference, class_name: "Language", optional: true
  belongs_to :hospital, optional: true
  belongs_to :state, optional: true
  belongs_to :onboarding_method, optional: true
  belongs_to :reference_user, class_name: "User", optional: true

  has_many :user_event_trackers, dependent: :destroy

  has_many :user_condition_area_mappings, dependent: :destroy
  has_many :condition_areas, through: :user_condition_area_mappings

  has_many :user_textit_group_mappings, dependent: :destroy

  has_one :rch_profile, dependent: :destroy
  has_one :tb_profile, dependent: :destroy

  def self.find_by_phone(phone)
    return find_user_by_phone(User, phone, :in)
  end

  def is_high_risk
    # TODO: check high risk column in rch_profiles
    return true
  end

  def can_create_alert
    return (
      self.is_high_risk and
      self.state&.name == "Andhra Pradesh" and
      [
        "Kolar",
        "Nellore",
      ].include? self.rch_profile&.district
    )
  end

  # after_save :update_whatsapp_id TODO - better way to do this

  # if the field `whatsapp_mobile_number` exists return that, else return mobile number
  def whatsapp_mobile_number
    super() || self.mobile_number
  end

  def international_whatsapp_number
    number = self.whatsapp_mobile_number[1..self.whatsapp_mobile_number.length]
    "+91#{number}"
  end

  def international_mobile_number
    number = self.mobile_number[1..self.mobile_number.length]
    "+91#{number}"
  end

  def sdh_user?
    self.program_id == NooraProgram.id_for(:sdh)
  end

  def name
    super() || self.rch_profile&.name
  end


  ######################## CONDITION AREA RELATED METHODS #############################

  # TODO - add an active lag to the user-condition-area mapping table to keep track of which intervention
  # the user is currently a part of. This will, by default, be the one that they signed up last

  # the below functions takes the program as an argument and returns the
  # ID of the latest condition area in that program that the user belongs to
  def retrieve_condition_area_id(program_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id).first&.condition_area_id
  end


  # the below functions takes the program as an argument and returns the
  # latest condition area in that program that the user belongs to
  def retrieve_condition_area(program_id)
    ConditionArea.find_by(id: self.retrieve_condition_area_id(program_id))
  end


  # this method adds a user to a condition area, for a given program
  def add_condition_area(program_id, condition_area_id)
    if self.user_condition_area_mappings.with_program_id(program_id).pluck(:condition_area_id).include?(condition_area_id)
      # do nothing, because the user already belongs to that particular condition area
    else
      return self.user_condition_area_mappings.build(condition_area_id: condition_area_id, noora_program_id: program_id).save
    end
  end

  # for a given program, it updates the condition area of the user
  # with the condition area passed in the argument
  # USE WITH CAUTION
  def update_condition_area(program_id, new_condition_area_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id).first&.update(condition_area_id: new_condition_area_id)
  end

  # the below method removed the condition area associated with a user
  def remove_condition_area(program_id, condition_area_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id, condition_area_id: condition_area_id).first&.destroy
  end

  ######################## CONDITION AREA RELATED METHODS #############################

  # this method will tell if a user is fully signed up to a particular program
  # of RES. For now, this means that the user has selected their language and condition area
  def fully_onboarded_to_res?(program_id, state_id = self.state_id, condition_area_id = self.condition_area_id)
    self.language_preference_id.present? &&
    self.user_condition_area_mappings.where(noora_program_id: program_id, condition_area_id: condition_area_id).present? &&
    self.signed_up_to_whatsapp &&
    self.state_id == state_id
  end

  def anc?(program_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id, condition_area_id: ConditionArea.id_for(:anc)).present?
  end

  def pnc?(program_id)
    self.user_condition_area_mappings.where(noora_program_id: program_id, condition_area_id: ConditionArea.id_for(:pnc)).present?
  end

  ######################## SIGNUP TRACKER RELATED METHODS #############################

  def add_signup_tracker(program_id, condition_area_id, language_id)
    self.user_event_trackers.build(condition_area_id: condition_area_id,
                                    program_id: program_id,
                                    language_id: language_id)
  end




  private

  # def update_whatsapp_id
  #   if self.signed_up_to_whatsapp && self.whatsapp_id.blank?
  #     op = TurnApi::UpdateWhatsappId.perform_async(self.id)
  #   end
  # end

end
