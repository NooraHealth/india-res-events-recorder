# == Schema Information
#
# Table name: health_alert_notifications
#
#  id              :bigint           not null, primary key
#  event_timestamp :datetime
#  platform        :string
#  user_type       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  health_alert_id :bigint           not null
#  user_id         :bigint
#
# Indexes
#
#  index_health_alert_notifications_on_health_alert_id  (health_alert_id)
#  index_health_alert_notifications_on_received_user    (user_type,user_id)
#
# Foreign Keys
#
#  fk_rails_...  (health_alert_id => health_alerts.id)
#
class HealthAlertNotification < ApplicationRecord
  belongs_to :health_alert
  belongs_to :user, polymorphic: true

  PATIENT_TYPE = "patient"
  ASHA_TYPE = "asha"
  ANM_TYPE = "anm"
  MO_TYPE = "mo"

  VALID_USER_TYPES = [
    PATIENT_TYPE,
    ASHA_TYPE,
    ANM_TYPE,
    MO_TYPE,
  ]

  validates_inclusion_of :user_type,
                         in: VALID_USER_TYPES,
                         message: "%{value} is not a valid user_type"

  has_many :responses, inverse_of: :health_alert_notification, class_name: "HealthAlertResponse"
end
