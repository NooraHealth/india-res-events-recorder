# frozen_string_literal: true


class Alerts::HcwListAlertedUsersController < ApplicationController

  def hcw_list_alerted_users
    listmaker = Alerts::HcwListAlertedUsers.new(
      self.logger,
      *params.require(
        [:phone, :serial_number,]
      )
    )

    return render json: {
                    success: true,
                    data: listmaker.list_alerted_users,
                  },
                  status: 200
  end
end
