
class HttpError < StandardError
  attr_reader :status

  def initialize(message, status = 500)
    super(message)
    @status = status
  end
end

class UserNotFound < HttpError
  attr_reader :status

  def initialize()
    super("User not found")
    @status = 404
  end
end

class InvalidPhone < HttpError
  attr_reader :status

  def initialize(message="Invalid phone")
    super(message)
    @status = 400
  end
end
