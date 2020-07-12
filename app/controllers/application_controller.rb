class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_template_vars
  before_action :set_naming_vars
  include Pundit

  def set_naming_vars
    if(!self.respond_to?("skip_naming") || !(self.skip_naming == true))
      @resource_name_root = self.class.name.match(/(?<model>\w*)Controller/)[:model]
      @resource_model_name = @resource_name_root.singularize
      @resource_collection_name = "@"+@resource_name_root.downcase
      @resource_instance_name = "@"+(@resource_model_name.underscore)
      @resource_model = @resource_model_name.constantize
    end
  end

  def set_resource(**args)
    if(args[:param].nil?)
      args[:param] = :id
    end
    if(args[:model].present?)
      short_param = args[:param]
      param_prefix = @resource_name_root.underscore.singularize
      long_param = (args[:model].to_s+"_#{args[:param].to_s}").to_sym
      model = args[:model].to_s.classify.constantize
      if(params[short_param].present?)
        search = {}
        search[short_param] = params[short_param]
        instance_variable_set(("@"+args[:model].to_s.underscore).to_sym, model.find_by(**search))
      elsif(params[long_param].present?)
        search = {}
        search[short_param] = params[long_param]
        instance_variable_set(("@"+args[:model].to_s.underscore).to_sym, model.find_by(**search))
      end
    else
      if(params[:action] == "new")
        instance_variable_set(@resource_instance_name.to_sym,@resource_model.new())
      elsif(params[:action] == "create")
        params_method_name = (@resource_name_root.singularize.downcase+"_params").to_sym
        instance_variable_set(@resource_instance_name.to_sym,@resource_model.new(self.send(params_method_name)))
      elsif(params[:action] == "index")
        instance_variable_set(@resource_collection_name.to_sym,@resource_model.all)
      else
        short_param = args[:param]
        param_prefix = @resource_name_root.underscore.singularize
        long_param = (param_prefix+"_#{args[:param].to_s}").to_sym
        if(params[short_param].present?)
          search = {}
          search[short_param] = params[short_param]
          instance_variable_set(@resource_instance_name.to_sym, @resource_model.find_by(**search))
        elsif(params[long_param].present?)
          search = {}
          search[short_param] = params[long_param]
          instance_variable_set(@resource_instance_name.to_sym, @resource_model.find_by(**search))
        end
      end
    end
  end

  def authorize_action
    if(params[:action] != "index")
      begin
        authorize(instance_variable_get(@resource_instance_name), (params[:action]+"?").to_sym)
      rescue
        message = redirect_message
        if(message.present?)
          redirect_to redirect_target, alert:message
        else
          redirect_to redirect_target
        end
      else
        puts "Authorized #{params[:action]}."
      end
    else
      instance_variable_set(@resource_collection_name, policy_scope(@resource_model_name.constantize))
    end
  end

  def redirect_target
    return "/"
  end

  def redirect_message
    if(params[:action] == "create" || params[:action] == "new")
      return "You are not authorized to create that item."
    elsif(params[:action] == "edit" || params[:action] == "update")
      return "You are not authorized to edit that item."
    elsif(params[:action] == "show" || params[:action] == "index")
      return "You are not authorized to view that item."
    else
      return "You are not authorized to edit that item."
    end
  end

  def filter_params(**args)
    if(args[:params].nil?)
      p = @resource_model.column_names
      p = p.reject{|c| (c.include?( "_at")) }
      if(args[:exclude].present?)
        args[:exclude].each do |name|
          p = p.reject{|c| c.to_sym == name.to_sym }
        end
      end
    else
      p = args[:params]
    end
    if(args[:include].present?)
      if(args[:include].is_a? Array)
        p = p.concat(args[:include])
      else
        p << args[:include]
      end
    end
    # p = p.map{|c| c = c.to_sym}
    return params.require(@resource_name_root.singularize.downcase.to_sym).permit(*p)
  end
  def requester_is_authorized(condition,target=nil)
    if(current_user.present? && condition)
      if(!target.nil?)
        render target
      end
      return true
    elsif(current_user.nil?)
      store_location_for(:user, request.env['PATH_INFO'])
      redirect_to "/users/sign_in"
      return false
    else
      redirect_to "/"
      return false
    end
  end

  def requester_is_staff
    return requester_is_authorized(current_user.present? && current_user.isStaff?)
  end

  def requester_is_admin
    return requester_is_authorized(current_user.present? && current_user.isAdmin?)
  end

  def load_template_vars
    @pages = Page.order(:id)
    @courses = Course.order(:id)
    @bible = Bible.find_by bible_id:"06125adad2d5898a-01"
  end
end
