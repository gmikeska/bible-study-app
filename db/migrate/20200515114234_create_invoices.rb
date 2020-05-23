class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.belongs_to :user
      t.string :payments
      t.string :number
    end
    change_table :enrollments do |t|
      t.references :invoice
    end
  end
end
