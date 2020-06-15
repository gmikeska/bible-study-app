class EventsComponent < CustomizableComponent
  def initialize(**args)
    @breeze_api = BreezeApi.new
    @events =  @breeze_api.events(start:Date.civil(2020, DateTime.now.strftime('%m').to_i, DateTime.now.strftime('%d').to_i).strftime('%y%y-%m-%d'),end:Date.civil(2020, DateTime.now.strftime('%m').to_i, -1).strftime('%y%y-%m-%d'))
    super(**args)
  end

  def component_params
    return super
  end
end
