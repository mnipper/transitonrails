class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  
  # A shortcut for finding model in before_filter and using
  #not_found if the model is missing.
  # So you can just do the following in your controller:
  #     class DealsController < ApplicationController
  #       find_model Deal, :only => :show
  #
  #       def show
  #         @deal.some_method # here @deal variable is auto set by "find_model" beforehand
  #       end
  #     end
  def self.find_model(clazz, scoped, options = {})
    before_filter(lambda { |c|
       model_id = "#{clazz.name.underscore}_id".to_sym
       id = c.params[model_id] || c.params[:id]
       model = eval([scoped, scoped ? clazz.name.tableize : clazz.name].compact.join(".")).find(id)
       return c.send(:not_found) unless model
       c.instance_variable_set("@#{clazz.name.underscore}", model)
    }, options)
  end
end
