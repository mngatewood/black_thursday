require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/item'
require_relative '../lib/item_repository'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
# require_relative './XoX'
# require_relative './XoX_repository'

class SalesEngineTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items          => "./data/items.csv",
      :merchants      => "./data/merchants.csv",
      :invoice_items  => "./data/invoice_items.csv"
      # :Xox          => "./data/XoX.csv"
    })
    @sa = @se.analyst
  end
  
  def test_it_exist
    assert_instance_of SalesEngine, @se
  end

  def test_it_starts_with_no_attributes
    @se = SalesEngine.new
    assert_nil @se.merchants
    assert_nil @se.items
  end
  
  def test_it_creates_a_sales_analyst
    assert_instance_of ItemRepository, @sa.items
    assert_equal 1367, @sa.items.collection.length
    assert_instance_of MerchantRepository, @sa.merchants
    assert_equal 475, @sa.merchants.collection.length
  end

  def test_it_converts_unit_price_string_to_a_big_decimal
    price_string_1 = BigDecimal(29.99, 4)
    price_string_2 = BigDecimal(9.99, 3)
    assert_equal price_string_1, @se.convert_integer_to_big_decimal(2999)
    assert_equal price_string_2, @se.convert_integer_to_big_decimal(999)
  end

  # 

  def test_creates_instance_of_merchant_repository
    assert_instance_of MerchantRepository, @se.merchants
    assert_equal 475, @se.merchants.collection.length
  end

  def test_it_loads_merchants_into_merchant_repository
    mr = @se.load_repository(MerchantRepository.new, "./data/merchants.csv")
    assert_instance_of MerchantRepository, mr
    assert_equal 475, mr.collection.length
  end

  # 

  def test_creates_instance_of_item_repository
    assert_instance_of ItemRepository, @se.items
    assert_equal 1367, @se.items.collection.length
  end

  def test_it_loads_items_into_item_repository
    ir = @se.load_repository(ItemRepository.new, "./data/items.csv")
    assert_instance_of ItemRepository, ir
    assert_equal 1367, ir.collection.length
  end

  # 

  def test_creates_instance_of_invoice_item_repository
    assert_instance_of InvoiceItemRepository, @se.invoice_items
    assert_equal 21830, @se.invoice_items.collection.length
  end

  def test_it_loads_invoice_items_into_invoice_item_repository
    iir = @se.load_repository(InvoiceItemRepository.new, "./data/invoice_items.csv")
    assert_instance_of InvoiceItemRepository, iir
    assert_equal 21830, iir.collection.length
  end

  # Copy and paste two tests above for XoX



end
