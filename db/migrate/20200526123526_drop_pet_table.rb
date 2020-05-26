class DropPetTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :pets
  end
end
