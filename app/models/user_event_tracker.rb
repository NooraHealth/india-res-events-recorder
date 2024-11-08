# == Schema Information
#
# Table name: user_event_trackers
#
#  id                   :bigint           not null, primary key
#  active               :boolean          default(FALSE)
#  call_direction       :string
#  call_sid             :string
#  call_status          :string
#  campaign_sid         :string
#  completed            :boolean
#  completed_at         :datetime
#  entity_type          :string
#  event_timestamp      :datetime
#  platform             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  condition_area_id    :bigint
#  entity_id            :bigint
#  event_type_id        :bigint
#  exophone_id          :bigint
#  language_id          :bigint
#  noora_program_id     :bigint
#  onboarding_method_id :bigint
#  qr_code_id           :bigint
#  sms_id               :string
#  state_id             :bigint
#  user_event_type_id   :bigint           default(1), not null
#  user_id              :bigint
#
# Indexes
#
#  index_user_event_trackers_on_call_sid              (call_sid)
#  index_user_event_trackers_on_condition_area_id     (condition_area_id)
#  index_user_event_trackers_on_entity                (entity_type,entity_id)
#  index_user_event_trackers_on_event_type_id         (event_type_id)
#  index_user_event_trackers_on_exophone_id           (exophone_id)
#  index_user_event_trackers_on_language_id           (language_id)
#  index_user_event_trackers_on_noora_program_id      (noora_program_id)
#  index_user_event_trackers_on_onboarding_method_id  (onboarding_method_id)
#  index_user_event_trackers_on_qr_code_id            (qr_code_id)
#  index_user_event_trackers_on_state_id              (state_id)
#  index_user_event_trackers_on_user_event_type_id    (user_event_type_id)
#  index_user_event_trackers_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (condition_area_id => condition_areas.id)
#  fk_rails_...  (event_type_id => event_types.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (noora_program_id => noora_programs.id)
#  fk_rails_...  (state_id => states.id)
#  fk_rails_...  (user_event_type_id => user_event_types.id)
#  fk_rails_...  (user_id => users.id)
#
class UserEventTracker < ApplicationRecord
  belongs_to :user
  belongs_to :condition_area, optional: true
  belongs_to :noora_program, optional: true
  belongs_to :language, optional: true
  belongs_to :onboarding_method, optional: true
  belongs_to :state, optional: true
  belongs_to :qr_code, optional: true
  belongs_to :exophone, optional: true

  validates :call_sid, uniqueness: true, allow_nil: true

end
