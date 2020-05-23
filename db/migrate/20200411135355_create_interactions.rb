class CreateInteractions < ActiveRecord::Migration[6.0]
  def change
    create_table :interactions do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.string :visibility
      t.string :interaction_type
      t.timestamps
    end
  end
end
