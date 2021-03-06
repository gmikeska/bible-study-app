require "api_gears"
class BreezeApi < ApiGears
  def initialize(**options)
    if(options[:params].nil?)
      options[:params] = {}
    end
    options[:query_interval] = 10
    subdomain = ENV.fetch("BREEZE_SUBDOMAIN")
    if(options[:Api_key].nil? && options[:params][:Api_key].nil?)
      options[:params]['Api-key'] = ENV.fetch("BREEZE_API_KEY")
    end

    url = "https://#{subdomain}.breezechms.com/api"

    super(url,options)
    endpoint "people"
    endpoint "person", path:'/people/{person_id}'
    endpoint "add_person", path:'/people/add', query_params:["first","last"]
    endpoint "delete_person", path:'/people/delete', query_params:["person_id"]

    endpoint "events", query_params:["start","end","category_id","eligible","details","limit"]
    endpoint "event", path:'events/list_event', query_params:["instance_id","schedule","schedule_direction","schedule_limit","eligible","details"]
    endpoint "calendars", path:'/events/calendars/list'
    endpoint "locations", path:'/events/locations'
    endpoint "add_event", path:'events/add', query_params:["name","starts_on","ends_on","all_day","description","category_id","event_id"]
    endpoint "delete_event", path:'events/delete', query_params:["instance_id"]
  end
  def request(**args)
    result = super
    result = prepare_data(result)
    return result
  end
end
