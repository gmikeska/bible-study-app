class CreateBitcoinPubkeys < ActiveRecord::Migration[6.0]
  def change
    create_table :bitcoin_pubkeys do |t|
      t.belongs_to :user
      t.string :public_key
      t.string :chain_code
      t.string :addresses
      t.string :key_path_base
      t.timestamps
    end
  end
end
