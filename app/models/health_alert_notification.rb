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

  has_many :responses, inverse_of: :health_alert_notification, class_name: "HealthAlertResponse"
end
