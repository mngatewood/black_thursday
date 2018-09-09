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

end
