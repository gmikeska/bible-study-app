class AddRefundedToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :refunded, :boolean
  end
end
