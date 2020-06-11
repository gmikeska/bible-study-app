class PagesController < ApplicationController
before_action :set_page, only: [:show, :edit, :update, :destroy]
  layout 'application'

  def index
    # @pages = Page.all
  end

  def home
    @page = Page.find_by slug:"home"
    @components = []
    @page.components.each do |component|
      @components << component[:name].camelcase.constantize.new(**component[:args].symbolize_keys)
    end
  end

  def show
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
    set_component
    if(@args.nil?)
      @args = (@component[:name]).camelcase.constantize.component_params.defaults
    end
    render(partial:"component_preview",layout:false, locals:{component:{name:@component[:name], args:@args}})
  end

  def component_settings
    set_component
    render(partial:"component_settings_embedded",layout:false, locals:{component:@component})
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
    return p
  end


  def set_component
    set_page

    if(params[:component_id].length > 1 && params[:component_id].to_i == 0)
      @component = {name:params[:component_id],args:params[:component_id].camelcase.constantize.component_params.defaults}
    else
      @component = @page.components[params[:component_id].to_i]
    end

    if(params[:args])
      @args = params[:args].permit!.to_h
    else
      @args = @component[:args]
    end
  end

  def set_page
    @page = Page.find_by slug: params[:slug]
  end


end
