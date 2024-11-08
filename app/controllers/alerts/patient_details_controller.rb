# frozen_string_literal: true


class Alerts::PatientDetailsController < ApplicationController

  def patient_details
    obj = Alerts::PatientDetails.new(
      self.logger,
      *params.require(
        [
          :hcw_type,
          :hcw_phone,
          :phone,
        ]
      )
    )

    return render json: {
                    success: true,
                    data: obj.get_details,
                  },
                  status: :created
  end
end
