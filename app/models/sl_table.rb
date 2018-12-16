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

  def pg
    @pg ||= MiniSql::Connection.new(ActiveRecord::Base.connection.raw_connection)
  end

  def definition
    selects = sl_columns.map do |column|
      column.expression
    end
    sql = <<~SQL
      SELECT id, #{selects.join(", ")} FROM #{SlRow.table_name}
    SQL
  end
end
