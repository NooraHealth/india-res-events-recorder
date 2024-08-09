################################## USAGE #################################
# This module is used typically for classes that tabulate types of a
# certain object. Like ContentType, UserType, MessageType etc.

# include this in any class to seed the data that you will need
# Inside each class you must define a class method called "values" which will contain
# all the various values that this model can contain

##########################################################################


module Seedable
  extend ActiveSupport::Concern

  class_methods do

    def values
      []
    end

    def id_for(name)
      find_by(name: name.to_s)&.id
    end

    def ids_for(*names)
      results = []
      names.each do |name|
        results << find_by(name: name.to_s)&.id
      end
      results.compact
    end

    def seed_data
      values.each do |value|
        next if find_by(name: value).present?
        create(name: value)
      end
    end
  end
end