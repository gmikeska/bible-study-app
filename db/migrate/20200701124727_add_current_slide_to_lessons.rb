class AddCurrentSlideToLessons < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :current_slide, :integer
  end
end
