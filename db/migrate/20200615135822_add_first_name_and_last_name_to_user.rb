class AddFirstNameAndLastNameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.find_each do |user|
      user.first_name = user.name.split(' ')[0]
      user.last_name = user.name.split(' ')[1]
      user.save!
    end
    remove_column :users, :name
  end
end
