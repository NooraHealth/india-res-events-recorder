
class HttpError < StandardError
  attr_reader :status

  def initialize(message, status = 500)
    super(message)
    @status = status
  end
end

class DuplicateResource < HttpError
  def initialize(message = "Duplicate resource")
    super(message, 409)
  end
end

class UserNotFound < HttpError
  def initialize()
    super("User not found", 404)
  end
end

class NotImplemented < HttpError
  def initialize(message="Not implemented")
    super(message, 500)
  end
end

class InvalidPhone < HttpError
  def initialize(message="Invalid phone")
    super(message, 400)
  end
end

class MultipleErrors < HttpError
  attr_reader :errors

  def initialize(message, errors, status = 500)
    super(message, status)
    @errors = errors
  end
end
