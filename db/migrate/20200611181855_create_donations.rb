class CreateDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :donations do |t|
      t.belongs_to :user
      t.monetize :amount
      t.monetize :amount_in_btc
      t.string :payment_method
      t.string :category
      t.string :payment_address
      t.timestamps
    end
  end
end
