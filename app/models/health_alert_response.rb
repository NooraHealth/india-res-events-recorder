# == Schema Information
#
# Table name: health_alert_responses
#
#  id                           :bigint           not null, primary key
#  platform                     :string
#  user_type                    :string           not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  health_alert_id              :bigint           not null
#  health_alert_notification_id :bigint           not null
#  user_id                      :bigint           not null
#
# Indexes
#
#  index_health_alert_responses_on_health_alert_id               (health_alert_id)
#  index_health_alert_responses_on_health_alert_notification_id  (health_alert_notification_id)
#  index_health_alert_responses_on_user                          (user_type,user_id)
#
# Foreign Keys
#
#  fk_rails_...  (health_alert_id => health_alerts.id)
#  fk_rails_...  (health_alert_notification_id => health_alert_notifications.id)
#
class HealthAlertResponse < ApplicationRecord
  belongs_to :health_alert_notification
  belongs_to :health_alert
  belongs_to :user

  PATIENT_TYPE = "patient"
  ASHA_TYPE = "asha"
  ANM_TYPE = "anm"

  VALID_USER_TYPES = [
    PATIENT_TYPE,
    ASHA_TYPE,
    ANM_TYPE,
  ]

  validates_inclusion_of :user_type,
                         in: VALID_USER_TYPES,
                         message: "%{value} is not a valid user_type"

  VALID_RESPONSES = ["YES", "NO"]
  validates_inclusion_of :response,
                          in: VALID_RESPONSES,
                          message: "%{value} is not a valid response"
end
