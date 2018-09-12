require 'pry'
require 'csv'
require 'bigdecimal'
require 'time'
require_relative './item'
require_relative './item_repository'
require_relative './merchant'
require_relative './merchant_repository'
require_relative './invoice_item'
require_relative './invoice_item_repository'

class SalesEngine
  attr_accessor :items,
                :merchants,
                :invoice_items

  def initialize
    @items          = nil
    @merchants      = nil
    @invoice_items  = nil
  end

  def inspect
    "#<#{self.class} #{@collection.size} rows>"
  end

  def self.from_csv(repositories)
    se = SalesEngine.new
    merchant_repository = se.load_merchant_repository(repositories[:merchants])
    item_repository = se.load_item_repository(repositories[:items])
    invoice_item_repository = se.load_invoice_item_repository(repositories[:invoice_items])

    se.merchants = merchant_repository
    se.items = item_repository
    se.invoice_items = invoice_item_repository
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
      mr.add_to_collection(m)
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
        :unit_price  => convert_integer_to_big_decimal(item[:unit_price]),
        :created_at  => Time.parse(item[:created_at]),
        :updated_at  => Time.parse(item[:updated_at]),
        :merchant_id => item[:merchant_id]
        })
      ir.add_to_collection(i)
    end
    return ir
  end

  def load_invoice_item_repository(invoice_items_data_path)
    iir = InvoiceItemRepository.new
    all_invoice_items = CSV.read(invoice_items_data_path, headers: true, header_converters: :symbol)
    all_invoice_items.each do |invoice_item|
      ii = InvoiceItem.new({
        :id          => invoice_item[:id],
        :item_id     => invoice_item[:item_id],
        :invoice_id  => invoice_item[:invoice_id],
        :quantity    => invoice_item[:quantity],
        :unit_price  => convert_integer_to_big_decimal(invoice_item[:unit_price]),
        :created_at  => Time.parse(invoice_item[:created_at]),
        :updated_at  => Time.parse(invoice_item[:updated_at]),
        })
      iir.add_to_collection(ii)
    end
    return iir
  end

  def convert_integer_to_big_decimal(unit_price)
    unit_price_length = unit_price.to_s.chars.length
    return BigDecimal.new(unit_price.to_f/100, unit_price_length)
  end

  def analyst
    SalesAnalyst.new(@items, @merchants, @invoice_items)
  end
end
