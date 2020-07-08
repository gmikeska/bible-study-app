class CreateFacebookVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :facebook_videos do |t|
      t.string :title
      t.string :slug
      t.string :video_url
      t.timestamps
    end
  end
end
