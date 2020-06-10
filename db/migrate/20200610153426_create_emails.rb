class CreateEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.string :name
      t.text :subject
      t.text :content

      t.timestamps
    end
  end
end
