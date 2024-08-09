# == Schema Information
#
# Table name: onboarding_methods
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class OnboardingMethod < ApplicationRecord

  include Seedable

  def self.values
    [
      :ivr,
      :sms,
      :whatsapp,
      :qr_code,
      :teletraining_call,
      :rch_portal_direct
    ]
  end
end
