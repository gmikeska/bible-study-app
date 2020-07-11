class RemoveWebhookColumnsFromFacebookVideos < ActiveRecord::Migration[6.0]
  def change
    remove_column :facebook_videos, :webhook_message
    remove_column :facebook_videos, :from_address
    remove_column :facebook_videos, :from_dns
    remove_column :facebook_videos, :signature
  end
end
