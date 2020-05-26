class ChangePetIdToUserIdOnEnrollments < ActiveRecord::Migration[6.0]
  def change
    add_column :enrollments, :user_id, :integer
    remove_column :enrollments, :pet_id
  end
end
