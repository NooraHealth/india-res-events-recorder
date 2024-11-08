require_relative '../app/exceptions/http.rb'


def parse_timestamp(time)
  begin
    return Time.parse(time)
  rescue
    raise HttpError.new("Invalid time: #{time}", 400)
  end
end


def find_user_by_phone(userClass, phone, region = "in")
  phone = Phonelib.parse(phone, region)
  if (
    phone.country_code != "91" or
    phone.national_number.length != 10 or
    phone.national_number.starts_with? "0"
  )
    raise InvalidPhone.new "Not a valid indian phone (#{phone.e164})"
  end

  user = userClass.find_by(mobile_number: "0" + phone.e164[3..])
  if user.nil?
    raise UserNotFound.new
  end

  return user
end
