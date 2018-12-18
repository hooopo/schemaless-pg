# == Schema Information
#
# Table name: sl_columns
#
#  created_at      :datetime         not null
#  id              :bigint(8)        not null, primary key
#  name            :string           not null
#  options         :string           default([]), is an Array
#  position        :integer          default(0)
#  private_type    :string           not null
#  public_type     :string
#  ref_sl_table_id :bigint(8)
#  ref_table_name  :string
#  sl_table_id     :bigint(8)
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_sl_columns_on_sl_table_id_and_name      (sl_table_id,name) UNIQUE
#  index_sl_columns_on_sl_table_id_and_position  (sl_table_id,position)
#

class SlColumn < ApplicationRecord
  NATIVE_DATABASE_TYPES = {
    string:      { name: "varchar" },
    text:        { name: "text" },
    integer:     { name: "integer"},
    float:       { name: "float" },
    decimal:     { name: "decimal" },
    datetime:    { name: "timestamp" },
    time:        { name: "time" },
    date:        { name: "date" },
    daterange:   { name: "daterange" },
    numrange:    { name: "numrange" },
    tsrange:     { name: "tsrange" },
    tstzrange:   { name: "tstzrange" },
    int4range:   { name: "int4range" },
    int8range:   { name: "int8range" },
    boolean:     { name: "boolean" },
    inet:        { name: "inet" },
    uuid:        { name: "uuid" },
    json:        { name: "json" },
    jsonb:       { name: "jsonb" },
    point:       { name: "point" },
    money:       { name: "money" }
  }

  belongs_to :sl_table
  belongs_to :ref_sl_table

  # TODO fix table name change
  after_create do 
    sl_table.create_or_replace_view!
  end

  after_update do 
    sl_table.create_or_replace_view!
  end

  after_destroy do 
    sl_table.create_or_replace_view!
  end

  def array_type?
    private_type.end_with?("[]")
  end

  def text_type?
    private_type == 'text'
  end

  def range_type?
    private_type =~ /range(\[\])?$/
  end

  def btree_index?
    return false if array_type?
    return false if range_type?
    return false if text_type?
    return true
  end

  def gin_index?
    # todo
  end

  def fulltext_index?
    text_type?
  end

  def ref_sl_table?
    ref_sl_table_id.present?
  end

  def ref_table?
    ref_table_name.present?
  end

  def create_index!
    ApplicationRecord.connection.execute(index_expression) if index_expression
  end

  def drop_index!
    ApplicationRecord.connection.execute("DROP INDEX IF EXISTS #{index_name}")
  end

  def index_name(idx_type = 'btree')
    ApplicationRecord.connection.quote_column_name([sl_table_id, idx_type, id, name].join("_"))
  end

  # TODO gin or fulltext
  def index_expression
    if btree_index?
      sql = <<~SQL
        CREATE INDEX CONCURRENTLY IF NOT EXISTS #{index_name} 
        ON sl_rows 
        USING BTREE (sl_table_id, CAST ((data ->> #{row_key}) AS #{private_type})) 
        WHERE sl_table_id = #{self.sl_table_id}
      SQL
    end
  end

  def expression
    %Q{(CAST (data ->> #{row_key} AS #{self.private_type})) AS #{ApplicationRecord.connection.quote_column_name(self.name)}}
  end

  def row_key
    ApplicationRecord.connection.quote(self.id.to_s)
  end
end
