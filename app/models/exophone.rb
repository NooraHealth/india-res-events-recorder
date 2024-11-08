# == Schema Information
#
# Table name: exophones
#
#  id                :bigint           not null, primary key
#  virtual_number    :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  condition_area_id :integer
#  language_id       :integer
#  program_id        :integer
#  state_id          :bigint
#
# Indexes
#
#  index_exophones_on_condition_area_id  (condition_area_id)
#  index_exophones_on_language_id        (language_id)
#  index_exophones_on_program_id         (program_id)
#  index_exophones_on_state_id           (state_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_area_id => condition_areas.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (program_id => noora_programs.id)
#  fk_rails_...  (state_id => states.id)
#
class Exophone < ApplicationRecord

  validates :virtual_number, uniqueness: true

  belongs_to :language, optional: true
  belongs_to :condition_area, optional: true
  belongs_to :program, class_name: "NooraProgram", optional: true
  belongs_to :state, optional: true

end
