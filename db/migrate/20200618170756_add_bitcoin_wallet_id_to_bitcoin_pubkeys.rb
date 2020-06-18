class AddBitcoinWalletIdToBitcoinPubkeys < ActiveRecord::Migration[6.0]
  def change
    add_column :bitcoin_pubkeys, :bitcoin_wallet_id, :integer
  end
end
