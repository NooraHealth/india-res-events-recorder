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

      @user_ids = @hcw_user.get_patient_profiles.map { |x| x.user.id }

      # TODO: use user names from here
      if @user_ids.length == 0
        raise Forbidden.new("User doesn't qualify for listing alerts")
      end

      @serial_number = ["true", "1", "y", "yes"].include? serial_number.to_s.downcase
    end


    def list_alerted_users

      if @hcw_user.class.name == "AnmUser"
        hcw_filter = {anm_user_id: @hcw_user.id}
      else
        hcw_filter = {asha_user_id: @hcw_user.id}
      end

      value = {
        hcw_type: @hcw_user.class.name,
        patient_names: [],
      }

      # TODO: recent_alerts and open_alerts can be combined
      sql = <<-SQL
        SELECT
          DISTINCT ON (user_id) id,
          created_at
        FROM health_alerts
        WHERE user_id = ANY(ARRAY[#{@user_ids.join(', ')}]::integer[])
        ORDER BY user_id, created_at desc
      SQL

      recent_alerts = ActiveRecord::Base.connection.exec_query(
        sql, "get_recent_alerts_given_user_ids"
      ).rows.map { |x| x[0] }

      if recent_alerts.length == 0
        return value
      end

      open_alerts =
        HealthAlert
          .left_outer_joins(notifications: :responses)
          .where(
            responses: { id: nil }, # no responses
            id: recent_alerts, # only check recent open alerts
          )

      if open_alerts.length == 0
        return value
      end

      names =
        User
          .includes(:state, :rch_profile)
          .left_joins(:health_alerts)
          .where(
            health_alerts: open_alerts,
            rch_profile: hcw_filter,
          )
          .order("health_alerts.created_at ASC")
          .map { |x| {name: x.name, phone: x.mobile_number} } # NOTE: pluck picks 2 values for some reason

      value[:patient_names] = names.each_with_index.map do |item, index|
        {
          name: "#{index + 1}. #{item[:name]}",
          phone: item[:phone],
        }
      end

      return value

    end

  end
end
