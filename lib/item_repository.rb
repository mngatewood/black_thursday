require 'time'
require_relative './repositories'

class ItemRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection = []
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
end
