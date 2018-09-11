require 'pry'
require_relative './repositories'

class MerchantRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection = []
  end

  def inspect
    "#<#{self.class} #{@collection.size} rows>"
  end
  
  def create(attributes)
    id = @collection.map{|merchant|merchant.id}.max + 1
    attributes[:id] = id
    m = Merchant.new(attributes)
    add_to_collection(m)
  end

  def update(id, attributes)
    merchant = find_by_id(id)
    keys = attributes.keys
    valid_keys = [:name]
    invalid_keys = keys - valid_keys
    invalid_keys.length == 0 ?
      update_object_attributes(merchant, attributes, keys) :
      "Invalid key(s): #{invalid_keys.join(", ")}"
  end

end
