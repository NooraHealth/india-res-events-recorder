# frozen_string_literal: true

# == Schema Information
#
# Table name: health_alert_notifications
#
#  id                 :bigint           not null, primary key
#  event_timestamp    :datetime
#  received_user_type :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  health_alert_id    :bigint           not null
#  received_user_id   :bigint
#
# Indexes
#
#  index_health_alert_notifications_on_health_alert_id  (health_alert_id)
#  index_health_alert_notifications_on_received_user    (received_user_type,received_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (health_alert_id => health_alerts.id)
#
class HealthAlertNotification < ApplicationRecord

end
