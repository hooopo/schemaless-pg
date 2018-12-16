class CreateSlColumns < ActiveRecord::Migration[5.2]
  def change
    create_table :sl_columns, comment: 'schemaless column' do |t|
      t.bigint :sl_table_id
      t.string :name, null: false
      t.integer :position, default: 0, comment: '排序位置'
      t.string :options, default: [], array: true, comment: '预设选项'
      t.string :public_type, comment: '外部类型'
      t.string :private_type, null: false, comment: '私有类型：int4,int8,varchar, text, int4[], float, money, timestamp, date, int4range, point'
      t.timestamps
    end
    add_index :sl_columns, [:sl_table_id, :name], unique: true
    add_index :sl_columns, [:sl_table_id, :position]
  end
end
