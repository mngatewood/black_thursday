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
    se.merchants = se.load_repository(MerchantRepository.new, repositories[:merchants])
    se.items = se.load_repository(ItemRepository.new, repositories[:items])
    se.invoice_items = se.load_repository(InvoiceItemRepository.new, repositories[:invoice_items])
    return se
  end

  def load_repository(repository, objects_data_path)
    all_rows = CSV.read(objects_data_path, headers: true, header_converters: :symbol)
    all_rows.each do |row|
      object = get_child_object(repository, row)
      repository.add_to_collection(object)
    end
    return repository
  end

  def get_child_object(repository, data)
    if repository.class == ItemRepository
      build_item_object(data)
    elsif repository.class == MerchantRepository
      build_merchant_object(data)
    elsif repository.class == InvoiceItemRepository
      build_invoice_item_object(data)
    else
      return nil
    end
  end

  def build_item_object(data)
    Item.new({
      :id          => data[:id],
      :name        => data[:name],
      :description => data[:description],
      :unit_price  => convert_integer_to_big_decimal(data[:unit_price]),
      :created_at  => Time.parse(data[:created_at]),
      :updated_at  => Time.parse(data[:updated_at]),
      :merchant_id => data[:merchant_id]
      })
  end

  def build_merchant_object(data)
    Merchant.new({
      :id   => data[:id],
      :name => data[:name]
      })
  end

  def build_invoice_item_object(data)
    InvoiceItem.new({
      :id          => data[:id],
      :item_id     => data[:item_id],
      :invoice_id  => data[:invoice_id],
      :quantity    => data[:quantity],
      :unit_price  => convert_integer_to_big_decimal(data[:unit_price]),
      :created_at  => Time.parse(data[:created_at]),
      :updated_at  => Time.parse(data[:updated_at]),
      })
  end

  def convert_integer_to_big_decimal(unit_price)
    unit_price_length = unit_price.to_s.chars.length
    return BigDecimal.new(unit_price.to_f/100, unit_price_length)
  end

  def analyst
    SalesAnalyst.new(@items, @merchants, @invoice_items)
  end
  
end
