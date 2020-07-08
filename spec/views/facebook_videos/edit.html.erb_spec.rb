require 'rails_helper'

RSpec.describe "facebook_videos/edit", type: :view do
  before(:each) do
    @facebook_video = assign(:facebook_video, FacebookVideo.create!())
  end

  it "renders the edit facebook_video form" do
    render

    assert_select "form[action=?][method=?]", facebook_video_path(@facebook_video), "post" do
    end
  end
end
