class CreateBitcoinWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :bitcoin_wallets do |t|
      t.integer :required_keys
      t.string :addresses
      t.integer :last_index
      t.timestamps
    end
  end
end
