require "rails_helper"

RSpec.describe FacebookVideosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/facebook_videos").to route_to("facebook_videos#index")
    end

    it "routes to #new" do
      expect(get: "/facebook_videos/new").to route_to("facebook_videos#new")
    end

    it "routes to #show" do
      expect(get: "/facebook_videos/1").to route_to("facebook_videos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/facebook_videos/1/edit").to route_to("facebook_videos#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/facebook_videos").to route_to("facebook_videos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/facebook_videos/1").to route_to("facebook_videos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/facebook_videos/1").to route_to("facebook_videos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/facebook_videos/1").to route_to("facebook_videos#destroy", id: "1")
    end
  end
end
