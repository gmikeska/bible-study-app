class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.string :visibility
      t.timestamps
    end
  end
end
