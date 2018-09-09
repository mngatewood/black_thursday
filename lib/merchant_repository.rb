require 'pry'

class MerchantRepository
  attr_reader :merchants

  def initialize
    @merchants = []
  end

  def add_merchant(merchant)
    @merchants << merchant
  end

  def all
    merchants
  end

  def find_by_id(id)
    merchants.find{|merchant|merchant.id == id}
  end

  def find_by_name(name)
    merchants.find{|merchant|merchant.name.downcase == name.downcase}
  end

  def find_all_by_name(name)
    merchants.find_all do |merchant|
      merchant.name.downcase.include?(name.downcase)
    end
  end

  def create(attributes)
    id = @merchants.map{|merchant|merchant.id}.max + 1
    attributes[:id] = id
    m = Merchant.new(attributes)
    add_merchant(m)
  end

  def update(id, attributes)
    m = find_by_id(id)
    valid_keys = [:name]
    keys = attributes.keys
    keys.each do |key|
      value = attributes[key]
      valid_keys.include?(key) && m.send("#{key}=",value)
    end
  end
  
  def delete(id)
    m = find_by_id(id)
    @merchants.delete(m)
  end

end
