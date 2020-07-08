require 'rails_helper'

RSpec.describe "facebook_videos/new", type: :view do
  before(:each) do
    assign(:facebook_video, FacebookVideo.new())
  end

  it "renders new facebook_video form" do
    render

    assert_select "form[action=?][method=?]", facebook_videos_path, "post" do
    end
  end
end
