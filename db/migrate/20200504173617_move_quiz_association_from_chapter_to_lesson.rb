class MoveQuizAssociationFromChapterToLesson < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :lesson_id, :integer
    remove_column :quizzes, :chapter_id
  end
end
