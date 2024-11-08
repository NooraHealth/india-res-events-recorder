require_relative '../../../lib/utils.rb'
require_relative '../../exceptions/http.rb'

class Alerts::PatientDetails < MessageEvents::Base

  def initialize(logger, hcw_type, hcw_phone, phone)
    super(logger)

    @user = User.find_by_phone(phone)
    unless @user.can_create_alert
      raise Forbidden.new("User doesn't qualify for alert creation")
    end

    if hcw_type == "AnmUser"
      hcw_user = AnmUser.find_by_phone(phone)
      if @user.rch_profile.anm_user.id != hcw_user.id
        raise Forbidden.new("User is not mapped to the given Asha")
      end

    elsif hcw_type == "AshaUser"
      hcw_user = AshaUser.find_by_phone(phone)
      if @user.rch_profile.anm_user.id != hcw_user.id
        raise Forbidden.new("User is not mapped to the given Asha")
      end

    else
      raise BadRequest.new("hcw_type can be one of AnmUser/AshaUser")
    end

  end

  def get_details
    last_notification_user = @user.get_most_recent_health_alert_notification
    last_notification_asha = @user.rch_profile.asha_user.get_most_recent_health_alert_notification(@user.id)
    last_notification_anm = @user.rch_profile.anm_user.get_most_recent_health_alert_notification(@user.id)

    if not last_notification_user
      raise RecordNotFound.new("No notification sent")
    end

    if (
      (last_notification_user&.responses&.length||0) > 0 or
      (last_notification_asha&.responses&.length||0) > 0 or
      (last_notification_anm&.responses&.length||0) > 0
    )
      raise RecordNotFound.new("Response already recorded")
    end

    return {
             name: @user.name,
             lmp: @user.last_menstrual_period || "",
             warning_sign: last_notification_user.health_alert.symptom,
           }
  end

end
