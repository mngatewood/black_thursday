require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'time'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice'

class InvoiceRepositoryTest < Minitest::Test

  def setup
    @ir = InvoiceRepository.new
    @invoice_1 = Invoice.new({
      :id          => 1,
      :customer_id => 2,
      :merchant_id => 3,
      :status      => "pending",
      :created_at  => Time.now,
      :updated_at  => Time.now,
    })
    @invoice_2= Invoice.new({
      :id          => 4,
      :customer_id => 2,
      :merchant_id => 3,
      :status      => "pending",
      :created_at  => Time.now,
      :updated_at  => Time.now,
    })
    @invoice_3 = Invoice.new({
      :id          => 7,
      :customer_id => 8,
      :merchant_id => 9,
      :status      => "pending",
      :created_at  => Time.now,
      :updated_at  => Time.now,
    })
    @invoice_4 = Invoice.new({
      :id          => 10,
      :customer_id => 11,
      :merchant_id => 12,
      :status      => "pending",
      :created_at  => Time.now,
      :updated_at  => Time.now,
    })
    @invoice_5 = Invoice.new({
      :id          => 13,
      :customer_id => 14,
      :merchant_id => 15,
      :status      => "pending",
      :created_at  => Time.now,
      :updated_at  => Time.now,
    })
  end

  def add_test_invoices
    @ir.add_to_collection(@invoice_1)
    @ir.add_to_collection(@invoice_2)
    @ir.add_to_collection(@invoice_3)
    @ir.add_to_collection(@invoice_4)
    @ir.add_to_collection(@invoice_5)
  end

  def test_it_exist
    assert_instance_of InvoiceRepository, @ir
  end

  def test_it_starts_with_no_invoices
    assert_equal [], @ir.collection
  end

  def test_can_add_a_single_invoices
    @ir.add_to_collection(@invoice_1)
    assert_equal [@invoice_1], @ir.collection
  end

  def test_it_can_add_several_invoices
    @ir.add_to_collection(@invoice_1)
    @ir.add_to_collection(@invoice_2)
    @ir.add_to_collection(@invoice_3)
    @ir.add_to_collection(@invoice_4)
    @ir.add_to_collection(@invoice_5)
    expected = [@invoice_1, @invoice_2, @invoice_3, @invoice_4, @invoice_5]
    assert_equal expected, @ir.collection
  end

  def test_it_can_return_all_invoices
    self.add_test_invoices
    expected = [@invoice_1, @invoice_2, @invoice_3, @invoice_4, @invoice_5]
    assert_equal expected, @ir.all
  end

  def test_it_can_find_a_invoice_by_id
    self.add_test_invoices
    assert_equal @ir.find_by_id(1), @invoice_1
    assert_nil @ir.find_by_id(0)
  end

  def test_it_can_find_all_invoices_by_merchant_id
    self.add_test_invoices
    expected = [@invoice_1, @invoice_2]
    assert_equal expected, @ir.find_all_by_merchant_id(3)
    assert_equal [], @ir.find_all_by_merchant_id(0)
  end

  def test_it_can_find_all_invoices_by_customer_id
    self.add_test_invoices
    expected = [@invoice_1, @invoice_2]
    assert_equal expected, @ir.find_all_by_customer_id(2)
    assert_equal [], @ir.find_all_by_customer_id(3)
  end

  def test_it_can_create_a_new_invoice
    self.add_test_invoices
    attributes = {
                  :id          => 16,
                  :customer_id => 17,
                  :merchant_id => 18,
                  :status      => "pending",
                  :created_at  => Time.now,
                  :updated_at  => Time.now,
                }
    @ir.create(attributes)
    invoice = @ir.collection.last
    assert_equal 14, invoice.id
    assert_equal "2018-09-08 00:00:00 -0600", invoice.created_at.to_s
    assert_equal "2018-09-09 00:00:00 -0600", invoice.updated_at.to_s
    assert_equal 18, invoice.merchant_id
  end

  def test_it_can_update_invoice_attributes
    self.add_test_invoices
    attributes = {
                  :id          => 16,
                  :customer_id => 17,
                  :merchant_id => 18,
                  :status      => "pending",
                  :created_at  => Time.now,
                  :updated_at  => Time.now,
                }
    invoice = @ir.find_by_id(1)
    original_udpated_at = invoice.updated_at
    @ir.update(18, attributes)
    assert_instance_of Time, invoice.updated_at
    refute_equal original_udpated_at, invoice.updated_at

    attributes = {
                  :id          => 16,
                  :customer_id => 17,
                  :merchant_id => 18,
                  :status      => "pending",
                  :created_at  => Time.now,
                  :updated_at  => Time.now,
                }
    invoice = @ir.find_by_id(2)
    assert_equal "Invalid key(s): weight, merchant_id", @ir.update(2, attributes)
  end

  def test_it_can_delete_an_invoice_by_id
    self.add_test_invoices
    @ir.delete(1)
    assert_nil @ir.find_by_id(1)
  end
end
