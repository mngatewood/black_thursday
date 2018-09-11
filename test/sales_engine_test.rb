require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/merchant'
require_relative '../lib/item'
require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_analyst'

class SalesEngineTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
  end
  
  def test_it_exist
    assert_instance_of SalesEngine, @se
  end

  def test_creates_instance_of_merchant_repository
    assert_instance_of MerchantRepository, @se.merchants
    assert_equal 475, @se.merchants.collection.length
  end

  def test_it_starts_with_no_attributes
    @se = SalesEngine.new
    assert_nil @se.merchants
    assert_nil @se.items
  end

  def test_it_loads_merchants_into_merchant_repository
    se = SalesEngine.new
    mr = se.load_merchant_repository("./data/merchants.csv")
    assert_instance_of MerchantRepository, mr
    assert_equal 475, mr.collection.length
  end

  def test_creates_instance_of_item_repository
    assert_instance_of ItemRepository, @se.items
    assert_equal 1367, @se.items.collection.length
  end

  def test_it_loads_items_into_item_repository
    se = SalesEngine.new
    ir = se.load_item_repository("./data/items.csv")
    assert_instance_of ItemRepository, ir
    assert_equal 1367, ir.collection.length
  end

  def test_it_creates_a_sales_analyst
    sa = @se.analyst
    assert_instance_of ItemRepository, sa.items
    assert_equal 1367, sa.items.collection.length
    assert_instance_of MerchantRepository, sa.merchants
    assert_equal 475, sa.merchants.collection.length
  end

  def test_it_converts_unit_price_string_to_a_big_decimal
    @se = SalesEngine.new
    price_string_1 = BigDecimal(29.99, 4)
    price_string_2 = BigDecimal(9.99, 3)
    assert_equal price_string_1, @se.convert_integer_to_big_decimal(2999)
    assert_equal price_string_2, @se.convert_integer_to_big_decimal(999)
  end

end
