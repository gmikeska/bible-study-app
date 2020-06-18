class RenameDonationsToPayments < ActiveRecord::Migration[6.0]
  def change
    rename_table :donations, :payments
    remove_column :invoices, :payments
    add_reference :payments, :invoice, foreign_key: true
    add_reference :payments, :bitcoin_pubkeys, foreign_key: true
    add_reference :payments, :bitcoin_wallet, foreign_key: true
  end
end
