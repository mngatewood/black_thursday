require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/transaction_repository'
require_relative '../lib/invoice_repository'
# require_relative '../lib/new_repository'

class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items          => "./data/items.csv",
      :merchants      => "./data/merchants.csv",
      :invoice_items  => "./data/invoice_items.csv",
      :transactions   => "./data/transactions.csv",
      :invoices       => "./data/invoices.csv"
    # :objects        => "./data/objects.csv"
    })
    @sa = @se.analyst
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @sa
  end

  def test_it_takes_in_arguments
    assert_instance_of ItemRepository, @sa.items
    assert_instance_of MerchantRepository, @sa.merchants
    assert_instance_of InvoiceItemRepository, @sa.invoice_items
    assert_equal 1367, @sa.items.collection.length
    assert_equal 475, @sa.merchants.collection.length
    assert_equal 21830, @sa.invoice_items.collection.length
  end

  def test_it_returns_average_number_of_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

  def test_it_returns_a_hash_of_number_of_items_sold_for_each_merchant
    assert_instance_of Hash, @sa.items_per_merchant
    assert_equal 475, @sa.items_per_merchant.keys.length
    assert_equal ["12334141", 1], @sa.items_per_merchant.first
  end

  def test_it_returns_standard_deviation_of_items_sold
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

  def test_it_can_return_average_unit_price_for_a_given_merchant
    expected = BigDecimal.new(31.50, 4)
    assert_equal expected, @sa.average_item_price_for_merchant(12334159)
  end

  def test_it_can_return_average_unit_price_for_another_given_merchant
    expected = BigDecimal.new(16.66, 4)
    assert_equal expected, @sa.average_item_price_for_merchant(12334105)
  end

  def test_it_returns_average_price_of_items_per_merchant
    assert_equal 350.29, @sa.average_average_price_per_merchant.to_f
  end

  def test_it_returns_the_average_price_of_all_items
    assert_equal 251.06, @sa.average_item_price.to_f
  end

  def test_it_returns_standard_deviation_of_item_price
    assert_equal 2900.99, @sa.average_item_price_standard_deviation.to_f
  end

  def test_it_returns_items_two_standard_deviations_above_average_price
    threshold = 6052.929041697147
    assert_equal 5, @sa.golden_items.length
    assert_instance_of Item, @sa.golden_items.first
    assert_equal 263410685, @sa.golden_items.first.id
    assert_equal 263558812, @sa.golden_items.last.id
    assert @sa.golden_items[0].unit_price > threshold
    assert @sa.golden_items[1].unit_price > threshold
    assert @sa.golden_items[2].unit_price > threshold
    assert @sa.golden_items[3].unit_price > threshold
    assert @sa.golden_items[4].unit_price > threshold
  end

end
