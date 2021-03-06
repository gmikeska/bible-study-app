class FacebookVideosController < ApplicationController
  before_action :set_facebook_video
  before_action :authenticate_user!, except:[:index, :show, :live]
  before_action :authorize_action, except:[:live]

  layout 'live'
  # GET /facebook_videos
  # GET /facebook_videos.json
  def index
    @facebook_videos = FacebookVideo.all.order("created_at DESC").reject{|v| v.slug.nil?}
  end

  # GET /facebook_videos/1
  # GET /facebook_videos/1.json
  def show
  end

  def live
    @facebook_video = FacebookVideo.all.order(created_at: :asc).last
  end

  # GET /facebook_videos/new
  def new
    @facebook_video = FacebookVideo.new
  end

  # GET /facebook_videos/1/edit
  def edit
  end

  # POST /facebook_videos
  # POST /facebook_videos.json
  def create
    @facebook_video = FacebookVideo.new(facebook_video_params)

    respond_to do |format|
      if @facebook_video.save
        format.html { redirect_to @facebook_video, notice: 'Facebook video was successfully created.' }
        format.json { render :show, status: :created, location: @facebook_video }
      else
        format.html { render :new }
        format.json { render json: @facebook_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facebook_videos/1
  # PATCH/PUT /facebook_videos/1.json
  def update
    respond_to do |format|
      if @facebook_video.update(facebook_video_params)
        format.html { redirect_to @facebook_video, notice: 'Facebook video was successfully updated.' }
        format.json { render :show, status: :ok, location: @facebook_video }
      else
        format.html { render :edit }
        format.json { render json: @facebook_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facebook_videos/1
  # DELETE /facebook_videos/1.json
  def destroy
    @facebook_video.destroy
    respond_to do |format|
      format.html { redirect_to facebook_videos_url, notice: 'Facebook video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facebook_video
      # params["slug"] = params["slug"].parameterize
      set_resource(param: :slug)
    end
    # Only allow a list of trusted parameters through.
    def facebook_video_params
      filter_params(params:[:title,:url,:video])
    end

    def facebook_video_webhook_params
      params.permit("hub.mode".to_sym,"hub.challenge".to_sym,"hub.verify_token".to_sym)
    end
end
