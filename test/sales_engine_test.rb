require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/merchant_repository'
require_relative '../lib/merchant'
require_relative '../lib/item'
require_relative '../lib/item_repository'



class SalesEngineTest < Minitest::Test
  def test_it_exist
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    assert_instance_of SalesEngine, se
  end

  def test_creates_instance_of_merchant_repository
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    assert_instance_of MerchantRepository, se.merchants
    assert_equal 475, se.merchants.merchants.length
  end

  def test_it_starts_with_no_attributes
    se = SalesEngine.new
    assert_nil se.merchants
    assert_nil se.items
  end

  def test_it_loads_merchants_into_merchant_repository
    se = SalesEngine.new
    mr = se.load_merchant_repository("./data/merchants.csv")
    assert_instance_of MerchantRepository, mr
    assert_equal 475, mr.merchants.length
  end

  def test_creates_instance_of_item_repository
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    assert_instance_of ItemRepository, se.items
    assert_equal 1367, se.items.items.length
  end

  def test_it_loads_items_into_item_repository
    se = SalesEngine.new
    ir = se.load_item_repository("./data/items.csv")
    assert_instance_of ItemRepository, ir
    assert_equal 1367, ir.items.length
  end

end
