require_relative '../../../lib/utils.rb'
require_relative '../../exceptions/http.rb'

module Alerts
  class HcwListAlertedUsers < MessageEvents::Base

    def initialize(logger, phone, serial_number)
      super(logger)

      begin
        @hcw_user = AnmUser.find_by_phone(phone)
      rescue UserNotFound
        @hcw_user = AshaUser.find_by_phone(phone)
      end

      unless @hcw_user.can_see_patient_alerts
        raise Forbidden.new("User doesn't qualify for listing alerts")
      end

      @serial_number = ["true", "1", "y", "yes"].include? serial_number.to_s.downcase
    end


    def list_alerted_users
      # sql = <<-SQL
      #   SELECT
      #     u.*,
      #     p.*,
      #     s.*
      #   FROM
      #     users AS u
      #       INNER JOIN states as s                      ON u.state_id = s.id
      #       INNER JOIN rch_profiles AS p                ON p.user_id = u.id
      #       LEFT JOIN health_alerts as ha               ON ha.user_id = u.id
      #       LEFT JOIN health_alert_notifications as han ON han.health_alert_id = ha.id
      #       LEFT JOIN health_alert_responses as has     ON has.health_alert_notification_id = han.id
      #   WHERE
      #     p.#{column} = #{@hcw_user.id}
      # SQL
      # users = User.find_by_sql([sql])

      if @hcw_user.class.name == "AnmUser"
        hcw_filter = {anm_user_id: @hcw_user.id}
      else
        hcw_filter = {asha_user_id: @hcw_user.id}
      end

      # TODO: the below 2 can be combined into 1 query (possibly raw?)
      recent_alerts =
        HealthAlert
          .select('DISTINCT ON (user_id) id, created_at')
          .order('user_id, created_at DESC')
          .pluck(:id)

      open_alerts =
        HealthAlert
          .left_outer_joins(notifications: :responses)
          .where(
            responses: { id: nil }, # no responses
            id: recent_alerts, # only check recent open alerts
          )

      names =
        User
          .includes(:state, :rch_profile)
          .left_joins(:health_alerts)
          .where(
            health_alerts: open_alerts,
            rch_profile: hcw_filter,
          )
          .order("health_alerts.created_at ASC")
          .pluck(:name)

      return names.each_with_index.map { |item, index| "#{index + 1}. #{item}" }

    end

  end
end
