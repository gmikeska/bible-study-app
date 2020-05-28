class AddMessagesToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :messages, :string
  end
end
