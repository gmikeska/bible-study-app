class AddRecipientsToEmails < ActiveRecord::Migration[6.0]
  def change
    add_column :emails, :recipients, :string
  end
end
