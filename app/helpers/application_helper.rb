module ApplicationHelper
  def link_to_add_fields(name, f, association)
    object_class = f.object.class.reflect_on_association(association).klass
    new_object = object_class.new
    object_symbol = object_class.to_s.downcase.to_sym
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render :partial => association.to_s.singularize + "_fields", :locals => {:f => builder, object_symbol => builder}
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
end
