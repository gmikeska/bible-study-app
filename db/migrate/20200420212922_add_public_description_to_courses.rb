class AddPublicDescriptionToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :summary, :text
    add_monetize :courses, :price
  end
end
