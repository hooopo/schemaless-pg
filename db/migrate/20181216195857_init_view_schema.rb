class InitViewSchema < ActiveRecord::Migration[5.2]
  def change
    execute("create schema if not exists sl_view")
  end
end
