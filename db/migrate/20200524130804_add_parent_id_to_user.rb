class AddParentIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :parent_id, :integer
  end
end
