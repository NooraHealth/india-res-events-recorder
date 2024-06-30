# == Schema Information
#
# Table name: textit_group_user_mappings
#
#  id              :bigint           not null, primary key
#  active          :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  textit_group_id :integer
#  user_id         :integer
#
# Indexes
#
#  index_textit_group_user_mappings_on_textit_group_id  (textit_group_id)
#  index_textit_group_user_mappings_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (textit_group_id => textit_groups.id)
#  fk_rails_...  (user_id => users.id)
#
class TextitGroupUserMapping < ApplicationRecord

  belongs_to :textit_group
  belongs_to :user
  
end
