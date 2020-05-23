class GalleriesController < ApplicationController
before_action :set_gallery, only: [:show, :edit, :update, :destroy]
  layout 'application'

  def index
    @galleries = Gallery.all
  end

  def show

  end

  def new

  end

  def create
    if @gallery.save
      redirect_to @gallery, notice: 'Gallery was successfully created.'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @gallery.update(gallery_params)
      redirect_to @gallery, notice: 'Gallery was successfully updated.'
    else
      render :edit
    end
  end

  def upload
    set_gallery
    if(params[:gallery][:files])
      @gallery.upload(params[:gallery])
    end
  end

  def show_files
    set_gallery
    render partial:"show_files"
  end

  def show_video
    set_gallery
    render :show_video
  end

  def destroy
    @gallery.destroy
    redirect_to galleries_url, notice: 'Gallery was successfully destroyed.'
  end
  private


  def gallery_params
    params.require(:gallery).permit(:name)
  end


  def set_gallery
    @gallery = Gallery.find_by id: params[:id]
    if(params[:fileid])
      @file = @gallery.files.find(params[:fileid])
    end
  end


end
