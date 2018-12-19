# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_18_191057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "sl_columns", comment: "schemaless column", force: :cascade do |t|
    t.bigint "sl_table_id"
    t.string "name", null: false
    t.integer "position", default: 0, comment: "排序位置"
    t.string "options", default: [], comment: "预设选项", array: true
    t.string "public_type", comment: "外部类型"
    t.string "private_type", null: false, comment: "私有类型：int4,int8,varchar, text, int4[], float, money, timestamp, date, int4range, point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ref_sl_table_id", comment: "引用的sl table id，用于schemaless table和schemaless table之间的关联"
    t.string "ref_table_name", comment: "引用的外部表名，用于和已存在是实体表之间的关联"
    t.index ["sl_table_id", "name"], name: "index_sl_columns_on_sl_table_id_and_name", unique: true
    t.index ["sl_table_id", "position"], name: "index_sl_columns_on_sl_table_id_and_position"
  end

  create_table "sl_rows", comment: "schemaless row", force: :cascade do |t|
    t.bigint "sl_table_id"
    t.jsonb "data", comment: "数据"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sl_table_id"], name: "index_sl_rows_on_sl_table_id"
  end

  create_table "sl_tables", comment: "schemaless table", force: :cascade do |t|
    t.string "name", comment: "表名"
    t.string "desc", comment: "描述"
    t.integer "user_id", comment: "创建者"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
