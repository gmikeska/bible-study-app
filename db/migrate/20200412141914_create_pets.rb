class CreatePets < ActiveRecord::Migration[6.0]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.date :birthday
      t.belongs_to :owner
      t.timestamps
    end
  end
end
