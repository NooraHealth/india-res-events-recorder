require_relative '../../../lib/utils.rb'
require_relative '../../exceptions/http.rb'

module Alerts
  class HcwPatientCare < MessageEvents::Base

    def initialize(logger, hcw_type, phone, patient_phone)

      super(logger)

      if hcw_type == "AnmUser"
        hcw_user = AnmUser.find_by_phone(phone)
      elsif hcw_type == "AshaUser"
        hcw_user = AshaUser.find_by_phone(phone)
      else
        raise BadRequest.new("hcw_type can be one of AnmUser/AshaUser")
      end

      user_ids = hcw_user.get_patient_profiles.map { |x| x.user.id }
      if user_ids.length == 0
        raise Forbidden.new("Hcw doesn't qualify for confirming care")
      end

      @patient_user = User.find_by_phone(phone)
      unless user_ids.include? @patient_user.id
        raise Forbidden.new("Asha is not allowed to confirm care for this user")
      end

      notification = hcw_user.get_most_recent_health_alert_notification(@patient_user.id)

      byebug

    end


    def confirm
      # TODO:
    end

    def deny
      # TODO:
    end

  end
end
