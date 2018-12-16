class CreateSlRows < ActiveRecord::Migration[5.2]
  def change
    create_table :sl_rows, comment: 'schemaless row' do |t|
      t.bigint :sl_table_id, index: true
      t.jsonb :data, comment: '数据'
      t.timestamps
    end
  end
end
