class AddDonationsToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :donations, :string
  end
end
