require "api_gears"
# require "byebug"
class FacebookGraphApi < ApiGears
  def initialize(**options)
    url = "https://graph.facebook.com/v7.0/"
    super(url,options)
    if(options[:init] == true)
      endpoint "init", path:"oauth/access_token", set_query_params:{grant_type:"fb_exchange_token",client_id:ENV.fetch("FB_APP_ID"),client_secret:ENV.fetch("FB_APP_SECRET"), fb_exchange_token:ENV.fetch("FB_SHORT_ACCESS_TOKEN")}
      long_token = self.init()["access_token"]
      if(long_token.present?)
        puts "Long access token acquired. Getting Page access token."
        endpoint "init", path:"memorialUnitedMethodistChurchAustin", set_query_params:{fields:"access_token",access_token:long_token}
        page_token = self.init()["access_token"]
        @endpoints.delete(:init)
        puts page_token
      else
        if(ENV.fetch("FB_PAGE_ACCESS_TOKEN").nil?)
          puts "please intialize with init:true to obtain a page_token, and then set page_token in credentials."
        end
      end
    else
      endpoint "videos",path:"memorialUnitedMethodistChurchAustin/videos", set_query_params:{access_token:ENV.fetch("FB_PAGE_ACCESS_TOKEN")}
      endpoint "live_videos",path:"memorialUnitedMethodistChurchAustin/live_videos", set_query_params:{access_token:ENV.fetch("FB_PAGE_ACCESS_TOKEN"),fields:"creation_time,permalink_url"}
      endpoint "video",path:"{video_id}", set_query_params:{access_token:ENV.fetch("FB_PAGE_ACCESS_TOKEN")}
    end
  end

end
