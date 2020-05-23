class AddSlidesToLessons < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :slides, :text
  end
end
