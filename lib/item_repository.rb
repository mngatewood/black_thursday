require 'pry'
require_relative './repositories'

class ItemRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection = []
  end

  def add_item(item)
    @collection << item
  end

  def find_by_id(id)
    collection.find{|item|item.id == id}
  end

  def find_all_by_price(price)
    collection.find_all do |item|
      item.unit_price_to_dollars == price.to_f
    end
  end

  def find_all_by_price_in_range(range)
    collection.find_all do |item|
      range.include?(item.unit_price_to_dollars)
    end
  end

  def create(attributes)
    id = @collection.map{|item|item.id}.max + 1
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
end
