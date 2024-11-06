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
require_relative '../../exceptions/http.rb'

class Alerts::CreateAlert < MessageEvents::Base

  def initialize(logger, phone, ticket_id, symptom, alert_identified_at)
    super(logger)
    @user = User.find_by_phone(phone)
    # TODO: add check for specific state and districts
    @ticket_id = ticket_id
    @alert_identified_at = parse_timestamp(alert_identified_at)
    @symptom = symptom
  end

  def create_alert
    alert = HealthAlert
              .left_outer_joins(notifications: :responses)
              .where(
                responses: { id: nil },
                ticket_id: @ticket_id,
                user_id: @user.id,
              )
              .order(created_at: :desc)
              .first

    if alert.nil?
      # TODO: update alert_identified_at, alert_id everywhere for users
      # Send HR message
      alert = HealthAlert.new(
        user_id: @user.id,
        ticket_id: @ticket_id,
        symptom: @symptom,
        alert_identified_at: @alert_identified_at,
      )
      unless alert.save
        raise MultipleErrors("Unable to create object", alert.errors.full_messages)
      end
      status = "created a new HealthAlert"

    else
      # TODO: update alert_id if > 5days
      if alert.symptom == @symptom
        raise DuplicateResource.new("HealthAlert already exists")
      else
        raise DuplicateResource.new("HealthAlert already exists with different symptom")
      end

    end

    return {
             status: status,
             alert_id: alert.id,
             symptom: alert.symptom,
           }
  end
end
