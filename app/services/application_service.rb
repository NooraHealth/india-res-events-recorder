# This is the parent service layer class. ALl service classes will inherit this class and implement a "call"]
# method that will be the only public method that will be used to contain the logic of the code

class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  # # the below is used for asynchronous running of any class
  # # that inherits this particular service, and will call the perform
  # def self.call_async(*args)
  #   new(*args).perform_async
  # end

  # this is the method where all the magic happens. All classes that inherit this
  # should implement a "call" method that will be the ONLY public method in that class

  def call

  end

end