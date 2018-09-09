require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'

class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
    @sa = SalesAnalyst.new(@se)
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @sa
  end

  def test_it_takes_in_arguments
    assert_instance_of ItemRepository, @sa.items
    assert_instance_of MerchantRepository, @sa.merchants
    assert_equal 1367, @sa.items.items.length
    assert_equal 475, @sa.merchants.merchants.length
  end

end