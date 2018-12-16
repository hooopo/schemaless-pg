# == Schema Information
#
# Table name: sl_columns
#
#  created_at   :datetime         not null
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  options      :string           default([]), is an Array
#  position     :integer          default(0)
#  private_type :string           not null
#  public_type  :string
#  sl_table_id  :bigint(8)
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_sl_columns_on_sl_table_id_and_name      (sl_table_id,name) UNIQUE
#  index_sl_columns_on_sl_table_id_and_position  (sl_table_id,position)
#

class SlColumn < ApplicationRecord
  belongs_to :sl_table

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

  NATIVE_DATABASE_TYPES = {
    primary_key: "bigserial primary key",
    string:      { name: "character varying" },
    text:        { name: "text" },
    integer:     { name: "integer", limit: 4 },
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
    binary:      { name: "bytea" },
    boolean:     { name: "boolean" },
    xml:         { name: "xml" },
    tsvector:    { name: "tsvector" },
    hstore:      { name: "hstore" },
    inet:        { name: "inet" },
    cidr:        { name: "cidr" },
    macaddr:     { name: "macaddr" },
    uuid:        { name: "uuid" },
    json:        { name: "json" },
    jsonb:       { name: "jsonb" },
    ltree:       { name: "ltree" },
    citext:      { name: "citext" },
    point:       { name: "point" },
    line:        { name: "line" },
    lseg:        { name: "lseg" },
    box:         { name: "box" },
    path:        { name: "path" },
    polygon:     { name: "polygon" },
    circle:      { name: "circle" },
    bit:         { name: "bit" },
    bit_varying: { name: "bit varying" },
    money:       { name: "money" },
    interval:    { name: "interval" },
    oid:         { name: "oid" },
  }

  def expression
    %Q{(CAST (data ->> #{ApplicationRecord.connection.quote(self.id.to_s)} AS #{self.private_type})) AS #{ApplicationRecord.connection.quote_column_name(self.name)}}
  end
end
