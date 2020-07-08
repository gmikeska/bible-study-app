class PagesController < ApplicationController
before_action :set_page, only: [:show, :edit, :update, :destroy]
  layout 'application'

  def index
    # @pages = Page.all
  end

  def home
    @page = Page.find_by slug:"home"
    @components = @page.components
  end

  def about_us
    # @page = Page.find_by slug:"home"
    # @components = []
    # @page.components.each do |component|
    #   @components << component[:name].camelcase.constantize.new(**component[:args].symbolize_keys)
    # end
    render "about-us"
  end

  def show
    @components = @page.components
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
    component_params
    render(partial:"component_preview",layout:false, locals:{component:ComponentSettings.new(@name,@args)})
  end

  def component_settings
    set_component
    render(partial:"component_settings_embedded",layout:false, locals:{component:@component})
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
    p = filter_params(:name,components:[:name,args:{}]).to_h.symbolize_keys
    p[:components] = p[:components].map{|c| c.to_h.symbolize_keys; }
    return p
  end

  def component_params
    if(params[:args])
      @args = params[:args].permit!.to_h.symbolize_keys
    end
    @name = params[:name].to_s
  end


  def set_component
    set_page
    id_is_name = (params[:component_id].present? && params[:component_id].to_i == 0 && params[:component_id] != "0")
    # byebug
    if(id_is_name)
      @component = ComponentSettings.new(params[:component_id])
    elsif(params[:component_id].present?)
      @component = @page.components[params[:component_id].to_i]
    end
  end

  def set_page
    set_resource(param: :slug)
  end


end
