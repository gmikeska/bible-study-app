class CreateVerses < ActiveRecord::Migration[6.0]
  def change
    create_table :verses do |t|
      t.references :bible
      t.string :verse_id
      t.text :content
      t.timestamps
      t.bigint :reading_id
    end
  end
end
