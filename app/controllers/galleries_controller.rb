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

  def file_select
    set_gallery
    render "file_select"
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

  def show_file
    set_gallery
  end

  def serve_file
    set_gallery
    send_data(@file.download,type:@file.content_type, filename:@file.filename.to_s)
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
    if(params[:gallery_id].present?)
      @gallery = Gallery.find(params[:gallery_id])
    elsif(params[:id].present?)
      @gallery = Gallery.find(params[:id])
    end
    if(params[:fileid])
      @file = @gallery.files.find(params[:fileid])
    elsif(params[:filename] && params[:action] != "serve_file")
      @file = @gallery.files.select{|f| f.filename.to_s == "#{params[:filename]}" }.first
    elsif(params[:filename] && params[:action] == "serve_file")
      @file =  @gallery.files.select{|f| f.filename.to_s == "#{params[:filename]}.#{params[:format]}"}.first
    end
  end


end
