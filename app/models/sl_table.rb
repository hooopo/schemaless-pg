# == Schema Information
#
# Table name: sl_tables
#
#  created_at :datetime         not null
#  desc       :string
#  id         :bigint(8)        not null, primary key
#  name       :string
#  updated_at :datetime         not null
#  user_id    :integer
#

class SlTable < ApplicationRecord
  has_many :sl_columns, -> { order(position: :asc)}
  has_many :sl_rows
end
