# == Schema Information
#
# Table name: textit_groups
#
#  id                   :bigint           not null, primary key
#  direct_entry         :boolean          default(FALSE)
#  exotel_number        :string
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  condition_area_id    :integer
#  language_id          :integer
#  onboarding_method_id :bigint
#  program_id           :integer
#  qr_code_id           :bigint
#  state_id             :bigint
#  textit_id            :string
#
# Indexes
#
#  index_textit_groups_on_condition_area_id     (condition_area_id)
#  index_textit_groups_on_onboarding_method_id  (onboarding_method_id)
#  index_textit_groups_on_program_id            (program_id)
#  index_textit_groups_on_qr_code_id            (qr_code_id)
#  index_textit_groups_on_state_id              (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_area_id => condition_areas.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (program_id => noora_programs.id)
#
class TextitGroup < ApplicationRecord

  validates :name, presence: true
  validates :textit_id, presence: true

  belongs_to :condition_area, optional: true
  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :language, optional: true
  belongs_to :state, optional: true
  belongs_to :onboarding_method, optional: true
  belongs_to :qr_code, optional: true

end
