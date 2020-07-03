class AddVideoIdToFacebookVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :facebook_videos, :video_id, :string
    remove_column :facebook_videos, :video_url, :string
  end
end
