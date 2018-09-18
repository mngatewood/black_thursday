require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/transaction_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/customer_repository'
# require_relative '../lib/new_repository'

class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items          => "./data/items.csv",
      :merchants      => "./data/merchants.csv",
      :invoice_items  => "./data/invoice_items.csv",
      :invoices       => "./data/invoices.csv",
      :transactions   => "./data/transactions.csv",
      :customers      => "./data/customers.csv"
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
    assert_instance_of InvoiceRepository, @sa.invoices
    assert_instance_of TransactionRepository, @sa.transactions
    assert_instance_of CustomerRepository, @sa.customers

    assert_equal 1367, @sa.items.collection.length
    assert_equal 475, @sa.merchants.collection.length
    assert_equal 21830, @sa.invoice_items.collection.length
    assert_equal 4985, @sa.invoices.collection.length
    assert_equal 4985, @sa.transactions.collection.length
    assert_equal 1000, @sa.customers.collection.length
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

  def test_it_returns_true_if_invoice_is_paid
    assert @sa.invoice_paid_in_full?(1)
    assert @sa.invoice_paid_in_full?(200)
    refute @sa.invoice_paid_in_full?(290)
    refute @sa.invoice_paid_in_full?(1752)
  end

  def test_it_returns_invoice_total_in_dollars
    assert_equal BigDecimal.new(21067.77, 7), @sa.invoice_total(1)
  assert_equal BigDecimal.new(5289.13, 6), @sa.invoice_total(2)
  assert_equal BigDecimal.new(0), @sa.invoice_total(0)
  end

  def test_it_returns_the_average_invoices_per_merchant
    assert_equal 10.49, @sa.average_invoices_per_merchant
  end

  def test_it_can_return_average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, @sa.average_invoices_per_merchant_standard_deviation
  end

  def test_it_returns_top_merchants_by_invoices
    assert @sa.top_merchants_by_invoice_count.include?(@sa.merchants.find_by_id(12336430))
    assert @sa.top_merchants_by_invoice_count.include?(@sa.merchants.find_by_id(12334146))
    assert @sa.top_merchants_by_invoice_count.include?(@sa.merchants.find_by_id(12335213))
    assert_equal 12, @sa.top_merchants_by_invoice_count.count
  end

  def test_it_returns_bottom_merchants_by_invoices
    assert @sa.bottom_merchants_by_invoice_count.include?(@sa.merchants.find_by_id(12334235))
    assert @sa.bottom_merchants_by_invoice_count.include?(@sa.merchants.find_by_id(12334601))
    assert @sa.bottom_merchants_by_invoice_count.include?(@sa.merchants.find_by_id(12335000))
    assert_equal 4, @sa.bottom_merchants_by_invoice_count.count
  end

  def test_it_can_return_the_top_days
    assert_equal ["Wednesday"], @sa.top_days_by_invoice_count
  end

  def test_it_can_return_the_percentage_of_status
    assert_equal 29.55, @sa.invoice_status(:pending)
    assert_equal 56.95, @sa.invoice_status(:shipped)
    assert_equal 13.5, @sa.invoice_status(:returned)
  end

  def test_it_returns_total_revenue_for_a_given_date
    date = Time.parse("2006-10-16")
    assert_equal BigDecimal.new(17022.32, 7), @sa.total_revenue_by_date(date)
  end

  def test_it_returns_an_array_of_top_performing_merchants_by_revenue
    assert_equal 3, @sa.top_revenue_earners(3).length
    assert_equal 20, @sa.top_revenue_earners.length
    assert_equal 10, @sa.top_revenue_earners(10).length
  end

  def test_it_returns_total_revenue_for_a_given_merchant
    expected = BigDecimal.new(126300.9, 7)
    assert_equal expected, @sa.revenue_by_merchant(12335938)
  end

  def test_it_returns_all_merchants_with_pending_invoices
    assert_equal 467, @sa.merchants_with_pending_invoices.count
    assert_instance_of Merchant, @sa.merchants_with_pending_invoices.first
  end

  def test_it_returns_true_if_invoice_is_pending
    assert @sa.pending_invoice?(9)
    refute @sa.pending_invoice?(1)
  end

  def test_it_returns_merchants_that_sell_only_one_item
    assert_equal 243, @sa.merchants_with_only_one_item.length
  end

  def test_it_can_return_merchants_with_one_item_per_month
    assert_equal 14, @sa.merchants_with_only_one_item_registered_in_month("March").length
  end

  def test_it_can_return_revenue_for_a_given_merchant
    assert_equal BigDecimal.new(65416.79, 7), @sa.revenue_by_merchant(12334194)
  end

  def test_it_can_return_the_most_sold_item_for_a_given_merchant
    item_ids = @sa.most_sold_item_for_merchant(12334189).map do |item|
      item.id
    end
    assert item_ids.include?(263524984)
  end

  def test_it_can_return_the_best_item_for_a_given_merchant
    item_ids = @sa.best_item_for_merchant(12334189)
    assert_equal 263516130, item_ids.id
  end
end
