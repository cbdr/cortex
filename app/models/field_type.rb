class FieldType
  include ActiveModel::Validations
  include ActiveSupport::DescendantsTracker

  def self.direct_descendant_names
    direct_descendants.map{ |descendant| descendant.name.underscore }
  end

  def self.get_subtype_constant(descendent_name)
    descendent_name.camelize.constantize
  end
end
