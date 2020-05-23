class AddAttendingMessagesAndStatusToInstructions < ActiveRecord::Migration[6.0]
  def change
    add_column :instructions, :attending, :string
    add_column :instructions, :messages, :string
    add_column :instructions, :status, :string
    remove_column  :instructions, :name
    remove_column  :instructions, :slug
    remove_column  :instructions, :description
  end
end
