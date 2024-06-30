# == Schema Information
#
# Table name: user_condition_area_mappings
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  condition_area_id :bigint
#  noora_program_id  :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_user_condition_area_mappings_on_condition_area_id  (condition_area_id)
#  index_user_condition_area_mappings_on_noora_program_id   (noora_program_id)
#  index_user_condition_area_mappings_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_area_id => condition_areas.id)
#  fk_rails_...  (noora_program_id => noora_programs.id)
#  fk_rails_...  (user_id => users.id)
#
class UserConditionAreaMapping < ApplicationRecord
  belongs_to :user
  belongs_to :condition_area
  belongs_to :noora_program


  scope :with_program_id, -> (program_id) do
    where(noora_program_id: program_id)
  end
end
