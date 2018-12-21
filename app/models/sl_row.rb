# == Schema Information
#
# Table name: sl_rows
#
#  created_at  :datetime         not null
#  data        :jsonb
#  id          :bigint(8)        not null, primary key
#  sl_table_id :bigint(8)
#  updated_at  :datetime         not null
#
# Indexes
#
#  2_btree_7_total               (sl_table_id, (((data ->> '7'::text))::numeric(10,2))) WHERE (sl_table_id = 2)
#  2_btree_9_age                 (sl_table_id, (((data ->> '9'::text))::integer)) WHERE (sl_table_id = 2)
#  2_btree_9_age_id              (sl_table_id, (((data ->> '9'::text))::integer), id) WHERE (sl_table_id = 2)
#  index_sl_rows_on_sl_table_id  (sl_table_id)
#

class SlRow < ApplicationRecord
  belongs_to :sl_table

  def self.pg_array(array = [])
    PG::TextEncoder::Array.new.encode(array).force_encoding('utf-8')
  end
end
