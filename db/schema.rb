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

ActiveRecord::Schema.define(version: 2018_12_21_101048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

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
    t.index "sl_table_id, (((data ->> '7'::text))::numeric(10,2))", name: "2_btree_7_total", where: "(sl_table_id = 2)"
    t.index "sl_table_id, (((data ->> '9'::text))::integer)", name: "2_btree_9_age", where: "(sl_table_id = 2)"
    t.index "sl_table_id, (((data ->> '9'::text))::integer), id", name: "2_btree_9_age_id", where: "(sl_table_id = 2)"
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
