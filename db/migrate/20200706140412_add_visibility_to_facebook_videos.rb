class AddVisibilityToFacebookVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :facebook_videos, :visibility, :integer
  end
end
