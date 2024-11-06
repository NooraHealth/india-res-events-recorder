# frozen_string_literal: true

# == Schema Information
#
# Table name: health_alerts
#
#  id                  :bigint           not null, primary key
#  alert_identified_at :datetime
#  symptom             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_health_alerts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class HealthAlert < ApplicationRecord
end
