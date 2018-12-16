class CreateSlTables < ActiveRecord::Migration[5.2]
  def change
    create_table :sl_tables, comment: 'schemaless table' do |t|
      t.string :name, comment: '表名'
      t.string :desc, comment: '描述'
      t.integer :user_id, comment: '创建者'
      t.timestamps
    end
  end
end
