module Repositories

  def delete(id)
    x = find_by_id(id)
    @collection.delete(x)
  end

  def find_by_name(name)
    all.detect do |element|
      element.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name_fragment)
    matches = []
    all.each do |element|
      if element.name.downcase.include?(name_fragment.downcase)
        matches << element
      end
    end
    return matches
  end

  def find_all_with_description(description)
    matches = []
    all.each do |element|
      if element.description.downcase.include?(description.downcase)
        matches << element
      end
    end
    return matches
  end

  def all
    @collection
  end

  def find_all_by_merchant_id(merchant_id)
    all.find_all do |item|
      item.merchant_id.to_i == merchant_id
    end
  end

  def find_all_by_item_id(item_id)
    all.find_all do |item|
      item.item_id == item_id
    end
  end

  def find_by_id(id)
    collection.find{|element|element.id == id}
  end

  def add_to_collection(object)
    @collection << object
  end

  def update_object_attributes(object, attributes, keys)
    if object
      keys.each do |key|
        value = attributes[key]
        object.send("#{key}=",value)
      end
      object.updated_at = Time.new
    end
  end

  def create_object(attributes, type)
    id = @collection.map{|element|element.id}.max + 1
    attributes[:id] = id
    object = get_object_of_type(attributes, type)
    add_to_collection(object)
  end

  def get_object_of_type(attributes, type)
    case type
    when "item" then Item.new(attributes)
    when "merchant" then Merchant.new(attributes)
    end
  end

end
