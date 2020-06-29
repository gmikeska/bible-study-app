class CreateHelps < ActiveRecord::Migration[6.0]
  def change
    create_table :helps do |t|
      t.string :title
      t.string :missing_sections
      t.string :slug
      t.string :category
      t.text :content
      t.boolean :system # used to indicate that this article documents system functions, created and edited by devs only.
      t.boolean :restricted # used to indicate that this article should only be visible/accessible to staff.

      t.timestamps
    end
  end
end
