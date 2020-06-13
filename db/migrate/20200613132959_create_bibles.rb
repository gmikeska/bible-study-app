class CreateBibles < ActiveRecord::Migration[6.0]
  def change
    create_table :bibles do |t|
      t.string :bible_id
      t.string :dblId
      t.string :name
      t.string :language
      t.string :language_id
      t.string :nameLocal
      t.string :abbreviation
      t.string :abbreviationLocal
      t.string :description
      t.string :descriptionLocal
      t.string :books
      t.string :copyright
      t.timestamps
    end
  end
end
