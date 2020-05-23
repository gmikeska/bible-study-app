class DropGooeyTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :gooey_components
    drop_table :gooey_designs
  end
end
