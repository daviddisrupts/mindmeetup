class CategorySerializer < ActiveModel::Serializer
  # attributes :id, :name, :subcategories

  # def subcategories
  # 	object.subcategoies if object.parent_id.blank?
  # end

  attributes :id, :name
  has_many :subcategories, unless: -> { object.subcategories.empty? }  
  
end
