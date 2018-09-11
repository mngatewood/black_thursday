require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'time'
require_relative '../lib/item'

class ItemTest < Minitest::Test

  def setup
    @item = Item.new({:id => 1, 
                      :name => "Pencil",
                      :description => "You can use it to write things",
                      :unit_price => BigDecimal.new(10.99,4),
                      :created_at => Time.new(2018, 9, 8, 0, 0, 0, "-06:00"),
                      :updated_at => Time.new(2018, 9, 9, 0, 0, 0, "-06:00"),
                      :merchant_id => 2
                    })
  end

  def test_it_exist
    assert_instance_of Item, @item
  end

  def test_it_has_attributes
    assert_equal 1, @item.id
    assert_equal "Pencil", @item.name
    assert_equal "You can use it to write things", @item.description
    assert_equal BigDecimal.new(10.99,4), @item.unit_price
    assert_equal "2018-09-08 00:00:00 -0600", @item.created_at.to_s
    assert_equal "2018-09-09 00:00:00 -0600", @item.updated_at.to_s
    assert_equal 2, @item.merchant_id
  end

  def test_it_returns_price_as_a_float
    assert_equal 10.99, @item.unit_price_to_dollars
  end

end
