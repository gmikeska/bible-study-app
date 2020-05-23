class CreateCoursesUsers < ActiveRecord::Migration[6.0]
  def change
    create_join_table :courses, :pets do |t|
      t.index :pet_id
      t.index :course_id
    end
  end
end
