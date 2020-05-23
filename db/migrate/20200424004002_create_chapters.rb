class CreateChapters < ActiveRecord::Migration[6.0]
  def change
    create_table :chapters do |t|
      t.string :name
      t.string :slug
      t.integer :course_id
      t.timestamps
    end
    add_column :lessons, :chapter_id, :integer
  end
end
