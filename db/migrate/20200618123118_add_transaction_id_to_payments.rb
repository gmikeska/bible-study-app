class AddTransactionIdToPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :transaction_id, :string
  end
end
