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

  def test_it_returns_average_number_of_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

  def test_it_returns_a_hash_of_number_of_items_sold_for_each_merchant
    assert_instance_of Hash, @sa.items_per_merchant
    assert_equal 475, @sa.items_per_merchant.keys.length
    assert_equal ["12334141", 1], @sa.items_per_merchant.first
  end

  def test_it_returns_standard_deviation
    assert_equal 3.26, @sa.average_items_per_merchant_standard_deviation
  end

  def test_it_returns_an_array_of_merchant_ids_that_sell_the_most_items
    assert_equal 52, @sa.merchant_ids_with_high_item_count.length
    assert_instance_of Array, @sa.merchant_ids_with_high_item_count
    assert_equal "12334195", @sa.merchant_ids_with_high_item_count.first
    assert_equal "12334522", @sa.merchant_ids_with_high_item_count.last
  end

  def test_it_returns_an_array_of_merchants_that_sell_the_most_items
    assert_equal 52, @sa.merchants_with_high_item_count.length
    assert_instance_of Array, @sa.merchants_with_high_item_count
    assert_instance_of Merchant, @sa.merchants_with_high_item_count.first
  end

end