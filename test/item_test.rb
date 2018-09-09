require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require_relative '../lib/item'

class ItemTest < Minitest::Test
  def test_it_exist
    i = Item.new({
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => BigDecimal.new(10.99,4),
      :created_at  => Time.now,
      :updated_at  => Time.now,
    })
    assert_instance_of Item, i
  end

  def test_it_has_attributes
    i = Item.new({
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => BigDecimal.new(10.99,4),
      :created_at  => Time.new(2018, 9, 8),
      :updated_at  => Time.new(2018, 10, 8),
    })

    assert_equal "Pencil", i.name
    assert_equal "You can use it to write things", i.description
    assert_equal BigDecimal.new(10.99,4), i.unit_price
    assert_equal "2018-09-08 00:00:00 -0600", i.created_at.to_s
    assert_equal "2018-10-08 00:00:00 -0600", i.updated_at.to_s
  end
end
