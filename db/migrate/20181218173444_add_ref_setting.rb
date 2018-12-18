class AddRefSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :sl_columns, :ref_sl_table_id, :bigint, comment: '引用的sl table id，用于schemaless table和schemaless table之间的关联'
    add_column :sl_columns, :ref_table_name, :string, comment: '引用的外部表名，用于和已存在是实体表之间的关联'
  end
end
