class AddSignatureToFacebookVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :facebook_videos, :signature, :string
  end
end
