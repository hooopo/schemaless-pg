class AddIndexing < ActiveRecord::Migration[5.2]
  def change
    enable_extension "btree_gin"
    enable_extension "btree_gist"
    enable_extension "pg_trgm"
    # USE_PGXS=1 pgxn install rum
    #enable_extension "rum" 
    # install zhparser first
    #enable_extension "zhparser"
  end
end
