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
require_relative './transaction'
require_relative './transaction_repository'
require_relative './invoice'
require_relative './invoice_repository'
require_relative './customer'
require_relative './customer_repository'

class SalesEngine

  attr_accessor :items,
                :merchants,
                :invoice_items,
                :invoices,
                :transactions,
                :customers
              # :XoX

  def initialize
    @items          = nil
    @merchants      = nil
    @invoice_items  = nil
    @invoices       = nil
    @transactions   = nil
    @customers      = nil
  end


  def self.from_csv(repositories)
    se = SalesEngine.new
    se.merchants = se.load_repository(MerchantRepository.new, repositories[:merchants])
    se.items = se.load_repository(ItemRepository.new, repositories[:items])
    se.invoice_items = se.load_repository(InvoiceItemRepository.new, repositories[:invoice_items])
    se.transactions = se.load_repository(TransactionRepository.new, repositories[:transactions])
    se.invoices = se.load_repository(InvoiceRepository.new, repositories[:invoices])
    se.customers = se.load_repository(CustomerRepository.new, repositories[:customers])
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

  def convert_integer_to_big_decimal(unit_price)
    unit_price_length = unit_price.to_s.chars.length
    return BigDecimal.new(unit_price.to_f/100, unit_price_length)
  end

  def analyst
    SalesAnalyst.new(@items, @merchants, @invoice_items, @invoices, @transactions, @customers)
  end

  def get_child_object(repository, data)
    case repository.class.to_s
    when "ItemRepository"         then build_item_object(data)
    when "MerchantRepository"     then build_merchant_object(data)
    when "InvoiceItemRepository"  then build_invoice_item_object(data)
    when "InvoiceRepository"      then build_invoice_object(data)
    when "TransactionRepository"  then build_transaction_object(data)
    when "CustomerRepository"     then build_customer_object(data)
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
      :name => data[:name],
      :created_at => Time.parse(data[:created_at])
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

  def build_transaction_object(data)
    Transaction.new({
      :id                           => data[:id],
      :invoice_id                   => data[:invoice_id],
      :credit_card_number           => data[:credit_card_number],
      :credit_card_expiration_date  => data[:credit_card_expiration_date],
      :result                       => data[:result].to_sym,
      :created_at                   => Time.parse(data[:created_at]),
      :updated_at                   => Time.parse(data[:updated_at])
      })
  end

  def build_invoice_object(data)
    Invoice.new({
      :id          => data[:id],
      :customer_id => data[:customer_id].to_i,
      :merchant_id => data[:merchant_id],
      :status      => data[:status].to_sym,
      :created_at  => Time.parse(data[:created_at]),
      :updated_at  => Time.parse(data[:updated_at])
      })
  end

  def build_customer_object(data)
    Customer.new({
      :id         => data[:id],
      :first_name => data[:first_name],
      :last_name  => data[:last_name],
      :created_at => Time.parse(data[:created_at]),
      :updated_at => Time.parse(data[:updated_at])
      })
  end
end
