# == Schema Information
#
# Table name: qr_codes
#
#  id                :bigint           not null, primary key
#  link_encoded      :string
#  name              :string
#  text_encoded      :string
#  text_identifier   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  condition_area_id :bigint
#  noora_program_id  :bigint
#  state_id          :bigint
#
# Indexes
#
#  index_qr_codes_on_condition_area_id  (condition_area_id)
#  index_qr_codes_on_noora_program_id   (noora_program_id)
#  index_qr_codes_on_state_id           (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (noora_program_id => noora_programs.id)
#  fk_rails_...  (state_id => states.id)
#
class QrCode < ApplicationRecord
  belongs_to :state
  belongs_to :noora_program
  belongs_to :condition_area, optional: true

  validates :text_identifier, uniqueness: true

  def self.id_from_text_identifier(text_identifier)
    QrCode.find_by(text_identifier: text_identifier)&.id
  end
end
