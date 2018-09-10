require 'pry'
require 'csv'
require 'bigdecimal'
class SalesEngine
  attr_accessor :merchants,
                :items

  def initialize
    @merchants = nil
    @items = nil
  end

  def self.from_csv(repositories)
    se = SalesEngine.new
    merchant_repository = se.load_merchant_repository(repositories[:merchants])
    item_repository = se.load_item_repository(repositories[:items])

    se.merchants = merchant_repository
    se.items = item_repository
    return se
  end

  def load_merchant_repository(merchants_data_path)
    mr = MerchantRepository.new
    all_merchants = CSV.read(merchants_data_path, headers: true, header_converters: :symbol)
    all_merchants.each do |merchant|
      m = Merchant.new({
        :id   => merchant[:id],
        :name => merchant[:name]
        })
      mr.add_merchant(m)
    end
    return mr
  end

  def load_item_repository(items_data_path)
    ir = ItemRepository.new
    all_items = CSV.read(items_data_path, headers: true, header_converters: :symbol)
    all_items.each do |item|
      i = Item.new({
        :id          => item[:id],
        :name        => item[:name],
        :description => item[:description],
        :unit_price  => item[:unit_price],
        :created_at  => item[:created_at],
        :updated_at  => item[:updated_at],
        :merchant_id => item[:merchant_id]
        })
      ir.add_item(i)
    end
    return ir
  end
end
