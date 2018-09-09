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
  end

  def test_creates_instance_of_item_repository
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    assert_instance_of ItemRepository, se.items
  end
end
