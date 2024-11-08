# frozen_string_literal: true


class Alerts::HcwPatientCareController < ApplicationController

  def confirm
    responder = Alerts::HcwPatientCare.new(
      self.logger,
      *params.require(
        [:hcw_type, :phone, :patient_phone, :platform,]
      )
    )

    return render json: {
                    success: true,
                    data: responder.confirm,
                  },
                  status: 200
  end

end
