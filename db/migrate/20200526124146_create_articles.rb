class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.boolean :show_in_feed, default: true
      t.timestamps
    end
  end
end
