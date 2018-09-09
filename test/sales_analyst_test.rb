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
    assert_equal 1367, @sa.items.length
    assert_equal 475, @sa.merchants.length
  end

  def test_it_returns_average_number_of_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

end