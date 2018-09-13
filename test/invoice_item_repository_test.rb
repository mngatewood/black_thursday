require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'time'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/invoice_item'

class InvoiceItemRepositoryTest < Minitest::Test

  def setup
    @iir = InvoiceItemRepository.new
    @invoice_item_1 = InvoiceItem.new({
      :id => 6,
      :item_id => 7,
      :invoice_id => 8,
      :quantity => 1,
      :unit_price => BigDecimal.new(10.99, 4),
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
      })
    @invoice_item_2 = InvoiceItem.new({
      :id => 7,
      :item_id => 1,
      :invoice_id => 8,
      :quantity => 1,
      :unit_price => BigDecimal.new(9.99, 3),
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
      })
    @invoice_item_3 = InvoiceItem.new({
      :id => 8,
      :item_id => 2,
      :invoice_id => 8,
      :quantity => 2,
      :unit_price => BigDecimal.new(19.99, 4),
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
      })
    @invoice_item_4 = InvoiceItem.new({
      :id => 9,
      :item_id => 3,
      :invoice_id => 9,
      :quantity => 3,
      :unit_price => BigDecimal.new(0.99, 2),
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
      })
    @invoice_item_5 = InvoiceItem.new({
      :id => 10,
      :item_id => 4,
      :invoice_id => 9,
      :quantity => 5,
      :unit_price => BigDecimal.new(50.99, 4),
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
      })
  end

  def add_test_invoice_items
    @iir.add_to_collection(@invoice_item_1)
    @iir.add_to_collection(@invoice_item_2)
    @iir.add_to_collection(@invoice_item_3)
    @iir.add_to_collection(@invoice_item_4)
    @iir.add_to_collection(@invoice_item_5)
  end

  def test_it_exist
    assert_instance_of InvoiceItemRepository, @iir
  end

  def test_it_starts_with_no_invoice_items
    assert_equal [], @iir.collection
  end

  def test_can_add_a_single_invoice_item
    @iir.add_to_collection(@invoice_item_1)
    assert_equal [@invoice_item_1], @iir.collection
  end

  def test_it_can_add_several_invoice_items
    @iir.add_to_collection(@invoice_item_1)
    @iir.add_to_collection(@invoice_item_2)
    @iir.add_to_collection(@invoice_item_3)
    @iir.add_to_collection(@invoice_item_4)
    @iir.add_to_collection(@invoice_item_5)
    expected = [@invoice_item_1, @invoice_item_2, @invoice_item_3, @invoice_item_4, @invoice_item_5]
    assert_equal expected, @iir.collection
  end

  def test_it_can_return_all_invoice_items
    self.add_test_invoice_items
    expected = [@invoice_item_1, @invoice_item_2, @invoice_item_3, @invoice_item_4, @invoice_item_5]
    assert_equal expected, @iir.all
  end

  def test_it_can_find_an_invoice_item_by_id
    self.add_test_invoice_items
    assert_equal @invoice_item_1, @iir.find_by_id(6)
    assert_nil @iir.find_by_id(0)
  end

  def test_it_can_find_all_invoices_item_by_invoice_id
    self.add_test_invoice_items
    expected = [@invoice_item_1, @invoice_item_2, @invoice_item_3]
    assert_equal expected, @iir.find_all_by_invoice_id(8)
    assert_equal [], @iir.find_all_by_invoice_id(0)
  end

  def test_it_can_create_a_new_invoice_item
    self.add_test_invoice_items
    attributes = {:item_id => 7,
                  :invoice_id => 8,
                  :quantity => 10,
                  :unit_price => BigDecimal.new(5.99, 3),
                  :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
                  :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
                  }
    @iir.create(attributes)
    invoice_item = @iir.collection.last
    assert_equal 11, invoice_item.id
    assert_equal 8, invoice_item.invoice_id
    assert_equal 10, invoice_item.quantity
    assert_equal BigDecimal.new(5.99, 3), invoice_item.unit_price
    assert_equal "2018-09-10 00:00:00 -0600", invoice_item.created_at.to_s
    assert_equal "2018-09-11 00:00:00 -0600", invoice_item.updated_at.to_s
  end

  def test_it_can_update_invoice_item_attributes
    self.add_test_invoice_items
    attributes = {:quantity => 100,
                  :unit_price => BigDecimal.new(4.99, 3)
                  }
    invoice_item = @iir.find_by_id(6)
    original_udpated_at = invoice_item.updated_at
    @iir.update(6, attributes)
    assert_equal 100, invoice_item.quantity
    assert_equal  BigDecimal.new(4.99, 3), invoice_item.unit_price
    refute_equal original_udpated_at, invoice_item.updated_at

    attributes = {:item_id => 7,
                  :merchant_id => 9
                  }
    assert_equal "Invalid key(s): item_id, merchant_id", @iir.update(7, attributes)
  end

  def test_it_can_delete_an_invoice_item_by_id
    self.add_test_invoice_items
    @iir.delete(6)
    assert_nil @iir.find_by_id(6)
  end

end
