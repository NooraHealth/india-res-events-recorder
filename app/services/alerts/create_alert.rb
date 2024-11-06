# this class parses the webhook params that come in from Turn.
# Format of the params:
# {
#   "statuses": [
#     {
#       "id": "ABGGFlA5FpafAgo6tHcNmNjXmuSf",
#       "status": "sent",
#       "timestamp": "1518694700",
#       "message": {
#         "recipient_id":"16315555555"
#       }
#     }
#   ]
# }

require_relative '../../../lib/utils.rb'

class Alerts::CreateAlert < MessageEvents::Base

  def initialize(logger, phone, ticket_id, symptom, alert_identified_at)
    super(logger)
    @user = User.find_by_phone(phone)
    @ticket_id = ticket_id
    @alert_identified_at = parse_timestamp(alert_identified_at)
    @symptom = symptom
  end

  def call
    return self
  end
end
