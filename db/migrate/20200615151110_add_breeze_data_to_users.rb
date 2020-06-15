class AddBreezeDataToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :breeze_data, :string
  end
end
