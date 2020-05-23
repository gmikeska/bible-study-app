class PagesController < ApplicationController
before_action :set_page, only: [:show, :edit, :update, :destroy]
  layout 'application'

  def index
    @pages = Page.all
  end

  def home
  end

  def show
    @pages = Page.all
    render params[:slug]
  end

  def new

  end

  def create
    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end



  def destroy
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end
  private


  def page_params
    params.require(:page).permit(:name)
  end


  def set_page
    @page = Page.find_by slug: params[:slug]
  end


end
