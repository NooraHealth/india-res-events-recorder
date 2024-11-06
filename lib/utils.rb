require_relative '../app/exceptions/http.rb'

def parse_timestamp(time)
  begin
    return Time.parse(time)
  rescue
    raise HttpError.new("Invalid time: #{time}", 400)
  end
end
