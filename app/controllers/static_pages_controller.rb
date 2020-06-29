class StaticPagesController < ApplicationController
before_action :set_page, only: [:show, :edit, :update, :destroy]
  layout 'application'

  def index
    return unless requester_is_staff
    # @pages = StaticPage.all
  end

  def home
    @page = StaticPage.find_by slug:"home"
    @components = @page.components
  end

  def about_us
    # @page = StaticPage.find_by slug:"home"
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
    return unless requester_is_staff
  end

  def create
    return unless requester_is_staff
    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  def edit
    return unless requester_is_staff
  end

  def component_preview
    return unless requester_is_staff
    component_params
    render(partial:"component_preview",layout:false, locals:{component:ComponentSettings.new(@name,@args)})
  end

  def component_settings
    return unless requester_is_staff
    set_component
    render(partial:"component_settings_embedded",layout:false, locals:{component:@component})
  end

  def update
    return unless requester_is_staff
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end



  def destroy
    return unless requester_is_staff
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end
  private


  def page_params
    p = params.require(:page).permit(:name,components:[:name,args:{}]).to_h.symbolize_keys
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
    @page = StaticPage.find_by slug: params[:slug]
  end


end
