class CreateEnrollments < ActiveRecord::Migration[6.0]
  def change
    create_table :enrollments do |t|
      t.integer :course_id
      t.integer :pet_id
      t.integer :current_chapter_id
      t.string :quiz_responses
      t.timestamps
    end
  end
end
