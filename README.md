# schemaless-pg

使用Postgres实现一个Leancloud Clone.

## 结构

### 表

```ruby
  create_table "sl_tables", comment: "schemaless table", force: :cascade do |t|
    t.string "name", comment: "表名"
    t.string "desc", comment: "描述"
    t.integer "user_id", comment: "创建者"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
```

### 列

```ruby
  create_table "sl_columns", comment: "schemaless column", force: :cascade do |t|
    t.bigint "sl_table_id"
    t.string "name", null: false
    t.integer "position", default: 0, comment: "排序位置"
    t.string "options", default: [], comment: "预设选项", array: true
    t.string "public_type", comment: "外部类型"
    t.string "private_type", null: false, comment: "私有类型：int4,int8,varchar, text, int4[], float, money, timestamp, date, int4range, point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sl_table_id", "name"], name: "index_sl_columns_on_sl_table_id_and_name", unique: true
    t.index ["sl_table_id", "position"], name: "index_sl_columns_on_sl_table_id_and_position"
  end
```

### 行

```ruby
  create_table "sl_rows", comment: "schemaless row", force: :cascade do |t|
    t.bigint "sl_table_id"
    t.jsonb "data", comment: "数据"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sl_table_id"], name: "index_sl_rows_on_sl_table_id"
  end
```

## 演示

### setup data

```ruby
t = SlTable.create(name: '订单表')
t.sl_columns.create(name: '客户名', public_type: '文本框', private_type: 'varchar')
t.sl_columns.create(name: '金额', public_type: '浮点数', private_type: 'decimal(10, 2)')
t.sl_columns.create(name: '下单日期', public_type: '日期', private_type: 'date')
t.sl_columns.create(name: '标签', public_type: '标签', private_type: 'varchar[]')
t.sl_rows.create(data: {'1': 'hooopo', '2': 50.88, '3': Date.today, '4': SlRow.pg_array(%w[土豪 电子产品爱好者])})
```

### view postgres

view专属的schema用来隔离和接口统一

```sql
schemaless-pg_development=# \dn
 List of schemas
  Name   | Owner
---------+--------
 public  | hooopo
 sl_view | hooopo // view专用schema，这样可以使表名和view名相同，通过设置search path，可以让使用者操作统一的SQL层查询接口
```

自动生成用户定义的view

```sql
schemaless-pg_development=# set search_path to sl_view;
schemaless-pg_development=# \dv
        List of relations
 Schema  |  Name  | Type | Owner
---------+--------+------+--------
 sl_view | 订单表 | view | hooopo
```

view的定义语句

```sql
schemaless-pg_development=# \d+ 订单表
                        View "sl_view.订单表"
  Column  |        Type         | Modifiers | Storage  | Description
----------+---------------------+-----------+----------+-------------
 id       | bigint              |           | plain    |
 客户名   | character varying   |           | extended |
 金额     | numeric(10,2)       |           | main     |
 下单日期 | date                |           | plain    |
 印象     | character varying[] |           | extended |
View definition:
 SELECT sl_rows.id,
    (sl_rows.data ->> '1'::text)::character varying AS "客户名",
    ((sl_rows.data ->> '2'::text))::numeric(10,2) AS "金额",
    (sl_rows.data ->> '3'::text)::date AS "下单日期",
    (sl_rows.data ->> '4'::text)::character varying[] AS "印象"
   FROM public.sl_rows
  WHERE sl_rows.sl_table_id = 1;
```

## Ruby 调用

```ruby
schemaless-pg(dev)> ap t.rows_from_view
[
    [0] {
          "id" => 2,
         "客户名" => "hooopo",
          "金额" => 50.88,
        "下单日期" => Mon, 17 Dec 2018,
          "印象" => [
            [0] "土豪",
            [1] "电子产品爱好者"
        ]
    },
    [1] {
          "id" => 3,
         "客户名" => "hooopo",
          "金额" => 50.88,
        "下单日期" => Mon, 17 Dec 2018,
          "印象" => [
            [0] "土豪",
            [1] "电子产品爱好者",
            [2] "rubyist"
        ]
    },
    [2] {
          "id" => 4,
         "客户名" => "hooopo",
          "金额" => 50.88,
        "下单日期" => Mon, 17 Dec 2018,
          "印象" => [
            [0] "土豪",
            [1] "电子产品爱好者",
            [2] "rubyist",
            [3] "100"
        ]
    }
]
```

## 表之间的引用

## 过滤和排序

## 搜索

## 报表

## 性能和索引相关

## Deployment

Ensure the following environment variables are set in the deployment environment:

* `POSTMARK_API_KEY`
* `RACK_ENV`
* `RAILS_ENV`
* `REDIS_URL`
* `SECRET_KEY_BASE`
* `SIDEKIQ_WEB_PASSWORD`
* `SIDEKIQ_WEB_USERNAME`

Optionally:

* `RAILS_LOG_TO_STDOUT`
* `RAILS_SERVE_STATIC_FILES`

[rbenv]:https://github.com/sstephenson/rbenv
[redis]:http://redis.io
[Homebrew]:http://brew.sh
