# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SlRow.delete_all
SlColumn.delete_all
SlTable.delete_all

product = SlTable.create(name: 'products')

name     = product.sl_columns.create(name: 'name', public_type: '文本框', private_type: 'varchar')
desc     = product.sl_columns.create(name: 'desc', public_type: '长文本', private_type: 'text')
p_date   = product.sl_columns.create(name: 'date', public_type: '日期', private_type: 'date')
price    = product.sl_columns.create(name: 'price', public_type: '浮点数', private_type: 'decimal(10, 2)')
category = product.sl_columns.create(name: 'category', public_type: '字符串', private_type: 'varchar')

100000.times do
  product.sl_rows.create(data: {
    name.id => rand(10) * 8,
    desc.id => rand(10) * 300,
    p_date.id => Date.today - rand(500),
    price.id =>  rand * 100,
    category.id => rand(10) * 6
  })
end

product_count = product.sl_rows.count

order = SlTable.create(name: 'orders')

customer_name = order.sl_columns.create(name: 'customer_name', public_type: '文本框', private_type: 'varchar')
total         = order.sl_columns.create(name: 'total', public_type: '浮点数', private_type: 'decimal(10, 2)')
date          = order.sl_columns.create(name: 'date', public_type: '日期', private_type: 'date')
age           = order.sl_columns.create(name: 'age', public_type: '整数', private_type: 'int4')
tags          = order.sl_columns.create(name: 'tags', public_type: '标签', private_type: 'varchar[]')
product_id    = order.sl_columns.create(name: 'product_id', public_type: '产品', private_type: 'int4', ref_sl_table_id: product.id)

1000000.times do 
  order.sl_rows.create(data: {
    customer_name.id => rand(10).to_s * 8, 
    total.id =>  rand * 100, 
    date.id => Date.today - rand(500), 
    age.id => rand(100),
    tags.id => SlRow.pg_array(%w[土豪 电子 产品 爱好者 电影 电商 电子 电动 电网 电击].sample(3)),
    product_id.id => rand(product_count) + 1
  })
end

ApplicationRecord.connection.execute("vacuum analyze sl_rows")


