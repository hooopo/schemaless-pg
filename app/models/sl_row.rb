# == Schema Information
#
# Table name: sl_rows
#
#  created_at  :datetime         not null
#  data        :jsonb
#  id          :bigint(8)        not null, primary key
#  sl_talbe_id :bigint(8)
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sl_rows_on_sl_talbe_id  (sl_talbe_id)
#

class SlRow < ApplicationRecord
  belongs_to :sl_table
end
