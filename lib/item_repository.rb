require 'pry'

class ItemRepository
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(item)
    @items << item
  end

  def all
    items
  end

  def find_by_id(id)
    items.find{|item|item.id == id}
  end

  def find_by_name(name)
    items.find{|item|item.name.downcase == name.downcase}
  end

  def find_all_with_description(description)
    items.find_all do |item|
      item.description.downcase.include?(description.downcase)
    end
  end

  def find_all_by_price(price)
    items.find_all do |item|
      item.unit_price_to_dollars == price.to_f
    end
  end

  def find_all_by_price_in_range(range)
    items.find_all do |item|
      range.include?(item.unit_price_to_dollars)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    items.find_all{|item|item.merchant_id == merchant_id}
  end

  def create(attributes)
    id = @items.map{|item|item.id}.max + 1
    attributes[:id] = id
    item = Item.new(attributes)
    add_item(item)
  end

  def update(id, attributes)
    item = find_by_id(id)
    keys = attributes.keys
    valid_keys = [:name, :description, :unit_price]
    invalid_keys = keys - valid_keys
    invalid_keys.length == 0 ? 
      update_item_attributes(item, attributes, keys) :
      "Invalid key(s): #{invalid_keys.join(", ")}"
  end
    
  def update_item_attributes(item, attributes, keys)
    keys.each do |key|
      value = attributes[key]
      item.send("#{key}=",value)
    end
    item.updated_at = "2018-09-10 00:00:00 -0600"
  end

  def delete(id)
    item = find_by_id(id)
    @items.delete(item)
  end



end
