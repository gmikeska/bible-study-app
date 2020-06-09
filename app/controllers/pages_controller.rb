class PagesController < ApplicationController
before_action :set_page, only: [:show, :edit, :update, :destroy]
  layout 'application'

  def index
    @pages = Page.all
  end

  def home
    @page = Page.find_by slug:"home"
    @components = []
    @page.components.each do |component|
      @components << component[:name].camelcase.constantize.new(**component[:args].symbolize_keys)
    end
  end

  def show
    @pages = Page.all
    @components = []
    @page.components.each do |component|
      @components << component[:name].camelcase.constantize.new(**component[:args].symbolize_keys)
    end
    # render params[:slug]
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

  def component_preview
    args = ((params[:component_name]+"_preview").camelcase.constantize.new.default)
    render(partial:"component_preview",layout:false, locals:{component_args:args})
  end

  def component_settings
    set_page
    render(partial:"component_settings_embedded",layout:false, locals:{component:{name:params[:component_name],args:{}}})
  end

  def update
    # byebug
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
    p = params.require(:page).permit!
    components = []
    p[:components].each do |comp|
      comp[:args].permit!
      comp[:args] = comp[:args].to_h.symbolize_keys
      components << comp
    end
    p[:components] = components
    # byebug
    return p
  end


  def set_page
    @page = Page.find_by slug: params[:slug]
  end


end
