# == Schema Information
#
# Table name: health_alerts
#
#  id                  :bigint           not null, primary key
#  alert_identified_at :datetime
#  symptom             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ticket_id           :string
#  user_id             :bigint           not null
#
# Indexes
#
#  index_health_alerts_on_ticket_id  (ticket_id)
#  index_health_alerts_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class HealthAlert < ApplicationRecord
  belongs_to :user

  # TODO: add orange and red types
  has_many :notifications, inverse_of: :health_alert, class_name: "HealthAlertNotification"
  # has_many :responses, inverse_of: :health_alert, class_name: "HealthAlertResponse"
end
