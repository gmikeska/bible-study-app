require 'rails_helper'

RSpec.describe "facebook_videos/index", type: :view do
  before(:each) do
    assign(:facebook_videos, [
      FacebookVideo.create!(),
      FacebookVideo.create!()
    ])
  end

  it "renders a list of facebook_videos" do
    render
  end
end
