
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

class RecordNotFound < HttpError
  def initialize(message = "Resource not found")
    super(message, 404)
  end
end

class UserNotFound < HttpError
  def initialize()
    super("User not found", 404)
  end
end

class Forbidden < HttpError
  def initialize(message = "Forbidden resource")
    super(message, 403)
  end
end

class UnprocessableEntity < HttpError
  def initialize(message="Unprocessable entity")
    super(message, 422)
  end
end

class NotImplemented < HttpError
  def initialize(message="Not implemented")
    super(message, 500)
  end
end

class BadRequest < HttpError
  def initialize(message="Bad request")
    super(message, 400)
  end
end

class InvalidPhone < BadRequest
  def initialize(message="Invalid phone")
    super(message)
  end
end

class MultipleErrors < HttpError
  attr_reader :errors

  def initialize(message, errors, status = 500)
    super(message, status)
    @errors = errors
  end
end
