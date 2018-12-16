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

  def definition
    selects = ["id"] + sl_columns.map do |column|
      column.expression
    end

    sql = <<~SQL
      SELECT #{selects.join(", ")} FROM #{SlRow.table_name} WHERE sl_table_id = #{self.id}
    SQL
  end

  def view_definition
    sql = <<~SQL
      CREATE OR REPLACE VIEW #{view_name} AS (
        #{definition}
      )
    SQL
  end

  def view_schema
    "sl_view"
  end

  def view_name
    [ApplicationRecord.connection.quote_table_name(view_schema), ApplicationRecord.connection.quote_table_name(name)].join(".")
  end
 
  def create_or_replace_view!
    ApplicationRecord.connection.execute("drop view if exists #{view_name}")
    ApplicationRecord.connection.execute(view_definition)
  end

  def pg
    @pg ||= MiniSql::Connection.new(ActiveRecord::Base.connection.raw_connection)
  end

  def rows_from_view
    pg.query_hash("select * from #{view_name}")
  end
end
