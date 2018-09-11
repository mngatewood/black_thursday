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

  def add_merchant(merchant)
    @collection << merchant
  end

  def all
    collection
  end

  def find_by_id(id)
    collection.find{|merchant|merchant.id == id}
  end

  def create(attributes)
    id = @collection.map{|merchant|merchant.id}.max + 1
    attributes[:id] = id
    m = Merchant.new(attributes)
    add_merchant(m)
  end

  def update(id, attributes)
    merchant = find_by_id(id)
    keys = attributes.keys
    valid_keys = [:name]
    invalid_keys = keys - valid_keys
    invalid_keys.length == 0 ?
      update_merchant_attributes(merchant, attributes, keys) :
      "Invalid key(s): #{invalid_keys.join(", ")}"
  end

  def update_merchant_attributes(merchant, attributes, keys)
    if merchant
      keys.each do |key|
        value = attributes[key]
        merchant.send("#{key}=",value)
      end
      merchant.updated_at = Time.new
    end
  end
end
