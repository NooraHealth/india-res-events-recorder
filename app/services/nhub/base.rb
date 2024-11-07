# Base class for parsing message event data coming in from Turn (mostly)

module Nhub
  class Base < ApplicationService
    attr_accessor :logger

    def initialize(logger)
      self.logger = logger
    end
  end
end
