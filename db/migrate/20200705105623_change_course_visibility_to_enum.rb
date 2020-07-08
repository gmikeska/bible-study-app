class ChangeCourseVisibilityToEnum < ActiveRecord::Migration[6.0]
  def change
    remove_column :courses, :visibility
    add_column :courses, :visibility, :integer
  end
end
