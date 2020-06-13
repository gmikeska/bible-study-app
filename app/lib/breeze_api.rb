class BreezeApi < ApiEngine
  def initialize(subdomain, **options)
    url = "https://#{subdomain}.breezechms.com/api"
    super(url,options)
    endpoint "people"
    endpoint "person", path:'/people/{person_id}'
    endpoint "add_person", path:'/people/add', query_params:["first","last"]
    endpoint "delete_person", path:'/people/delete', query_params:["person_id"]
  end
end
