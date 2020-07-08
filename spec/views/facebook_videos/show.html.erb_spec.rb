require 'rails_helper'

RSpec.describe "facebook_videos/show", type: :view do
  before(:each) do
    @facebook_video = assign(:facebook_video, FacebookVideo.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
