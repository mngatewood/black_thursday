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
    ir = ItemRepository.new
    mr = MerchantRepository.new
    file_path = repositories[:merchants]
    all_merchants = CSV.read(file_path, headers: true, header_converters: :symbol)
    all_merchants.each do |merchant|
      m = Merchant.new({:id => merchant[0], :name => merchant[1]})
      mr.add_merchant(m)
    end
    se.merchants = mr

    file_path = repositories[:items]
    all_items = CSV.read(file_path, headers: true, header_converters: :symbol)
    all_items.each do |item|
      i = Item.new({
        :name        => "Pencil",
        :description => "You can use it to write things",
        :unit_price  => BigDecimal.new(10.99,4),
        :created_at  => Time.now,
        :updated_at  => Time.now,
      })
      ir.add_item(i)
    end
    se.items = ir
    return se
  end
end
