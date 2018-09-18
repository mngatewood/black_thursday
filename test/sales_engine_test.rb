require_relative './helper_test'
require_relative '../lib/item'
require_relative '../lib/item_repository'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction'
require_relative '../lib/transaction_repository'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'
require_relative '../lib/customer'
require_relative '../lib/customer_repository'


class SalesEngineTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items          => "./data/items.csv",
      :merchants      => "./data/merchants.csv",
      :invoice_items  => "./data/invoice_items.csv",
      :transactions   => "./data/transactions.csv",
      :invoices       => "./data/invoices.csv",
      :customers      => "./data/customers.csv"
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
    assert_nil @se.invoice_items
    assert_nil @se.invoices
    assert_nil @se.transactions
    assert_nil @se.customers
  end

  def test_it_creates_a_sales_analyst
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

  def test_it_converts_unit_price_string_to_a_big_decimal
    price_string_1 = BigDecimal(29.99, 4)
    price_string_2 = BigDecimal(9.99, 3)
    assert_equal price_string_1, @se.convert_integer_to_big_decimal(2999)
    assert_equal price_string_2, @se.convert_integer_to_big_decimal(999)
  end


  def test_creates_instance_of_merchant_repository
    assert_instance_of MerchantRepository, @se.merchants
    assert_equal 475, @se.merchants.collection.length
  end

  def test_it_loads_merchants_into_merchant_repository
    mr = @se.load_repository(MerchantRepository.new, "./data/merchants.csv")
    assert_instance_of MerchantRepository, mr
    assert_equal 475, mr.collection.length
  end

  def test_creates_instance_of_item_repository
    assert_instance_of ItemRepository, @se.items
    assert_equal 1367, @se.items.collection.length
  end

  def test_it_loads_items_into_item_repository
    ir = @se.load_repository(ItemRepository.new, "./data/items.csv")
    assert_instance_of ItemRepository, ir
    assert_equal 1367, ir.collection.length
  end


  def test_creates_instance_of_invoice_item_repository
    assert_instance_of InvoiceItemRepository, @se.invoice_items
    assert_equal 21830, @se.invoice_items.collection.length
  end

  def test_it_loads_invoice_items_into_invoice_item_repository
    iir = @se.load_repository(InvoiceItemRepository.new, "./data/invoice_items.csv")
    assert_instance_of InvoiceItemRepository, iir
    assert_equal 21830, iir.collection.length
  end


  def test_creates_instance_of_transaction_repository
    assert_instance_of TransactionRepository, @se.transactions
    assert_equal 4985, @se.transactions.collection.length
  end

  def test_it_loads_transactions_into_transaction_repository
    tr = @se.load_repository(TransactionRepository.new, "./data/transactions.csv")
    assert_instance_of TransactionRepository, tr
    assert_equal 4985, tr.collection.length
  end

  def test_creates_instance_of_invoice_repository
    assert_instance_of InvoiceRepository, @se.invoices
    assert_equal 4985, @se.invoices.collection.length
  end

  def test_it_loads_invoices_into_invoice_repository
    ir = @se.load_repository(InvoiceRepository.new, "./data/invoices.csv")
    assert_instance_of InvoiceRepository, ir
    assert_equal 4985, ir.collection.length
  end



  def test_creates_instance_of_customer_repository
    assert_instance_of CustomerRepository, @se.customers
    assert_equal 1000, @se.customers.collection.length
  end

  def test_it_loads_customers_into_customer_repository
    cr = @se.load_repository(CustomerRepository.new, "./data/customers.csv")
    assert_instance_of CustomerRepository, cr
    assert_equal 1000, cr.collection.length
  end
end
