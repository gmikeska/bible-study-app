class AddWebHookMessageFieldToFacebookVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :facebook_videos, :webhook_message, :string
    add_column :facebook_videos, :from_address, :string
    add_column :facebook_videos, :from_dns, :string
  end
end
