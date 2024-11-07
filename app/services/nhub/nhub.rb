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

require 'net/http'
require_relative '../../../lib/utils.rb'
require_relative '../../exceptions/http.rb'

class Nhub::Nhub < MessageEvents::Base

  def initialize(logger, base_url, api_key)
    super(logger)
    @base_url = base_url
    @api_key = api_key
    uri = URI.parse(base_url)
    @http = Net::HTTP.new(uri.host, uri.port)
    @http.use_ssl = true if uri.scheme == 'https'
  end

  def update_user_attribute(phone: , attribute: , value: , update_back: true, client_timestamp: nil, converter: "default")
    url = self.get_update_url(phone)
    request_data = {
      meta_field: attribute,
      field_value: value,
      update_back: update_back,
      timestamp: (client_timestamp or Time.now.utc),
      converter: converter,
    }
    data, response = self.get_http_response(Net::HTTP::Patch, url, request_data)

    unless data and data["status"] == "queued"
      self.logger.error("Nhub update failed: url=#{url} data=#{request_data} http_status=#{response.code} http_body=#{response.body}")
    end

    return data, response
  end

  def get_update_url(phone)
    return @base_url + "/user/" + phone + "/update"
  end

  def get_http_response(method, url, data)
    request = method.new(
      url,
      {
        'Content-Type' => 'application/json',
        'Authorization' => @api_key,
      },
    )
    request.body = data.to_json
    response = @http.request(request)
    data = nil
    begin
      data = JSON.parse(response.body)
    rescue JSON::ParserError
    end
    return data, response
  end
end