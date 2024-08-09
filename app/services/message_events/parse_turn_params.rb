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

class ParseTurnStatusWebhook < MessageEvents::Base

  def initialize(logger, params)
    super(logger)
    self.params = params
  end

  def call

  end
end
