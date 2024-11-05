# frozen_string_literal: true

# == Schema Information
#
# Table name: user_hcw_mappings
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  anm_user_id  :bigint           not null
#  asha_user_id :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_user_hcw_mappings_on_anm_user_id   (anm_user_id)
#  index_user_hcw_mappings_on_asha_user_id  (asha_user_id)
#  index_user_hcw_mappings_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (anm_user_id => anm_users.id)
#  fk_rails_...  (asha_user_id => asha_users.id)
#  fk_rails_...  (user_id => users.id)
#
class UserHcwMapping < ApplicationRecord

end
