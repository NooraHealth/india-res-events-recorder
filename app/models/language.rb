# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  iso_code   :string
#
class Language < ApplicationRecord

  def self.values
    [
      :english,
      :hindi,
      :kannada,
      :telugu,
      :punjabi,
      :marathi
    ]
  end

  # code here can be a symbol or a string
  def self.with_code(code)
    find_by(iso_code: code.to_s)
  end
end
