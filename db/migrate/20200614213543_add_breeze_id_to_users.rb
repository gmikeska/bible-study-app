class AddBreezeIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :breeze_id, :string
  end
end
