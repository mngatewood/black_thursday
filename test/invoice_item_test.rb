require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require 'bigdecimal'
require_relative '../lib/invoice_item'
require_relative '../lib/item'

class ItemTest < Minitest::Test

  def setup
    @invoice_item = InvoiceItem.new({:id => 6,
                                 :item_id => 7,
                                 :invoice_id => 8,
                                 :quantity => 1,
                                 :unit_price => BigDecimal.new(10.99, 4),
                                 :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
                                 :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
                                })
  end

  def test_it_exist
    assert_instance_of InvoiceItem, @invoice_item
  end

  def test_it_has_attributes
    assert_equal 6, @invoice_item.id
    assert_equal 7, @invoice_item.item_id
    assert_equal 8, @invoice_item.invoice_id
    assert_equal 1, @invoice_item.quantity
    assert_equal BigDecimal.new(10.99,4), @invoice_item.unit_price
    assert_equal "2018-09-10 00:00:00 -0600", @invoice_item.created_at.to_s
    assert_equal "2018-09-11 00:00:00 -0600", @invoice_item.updated_at.to_s
  end

  def test_it_returns_price_as_a_float
    assert_equal 10.99, @invoice_item.unit_price_to_dollars
  end

end