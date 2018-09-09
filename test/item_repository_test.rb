require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require_relative '../lib/item_repository'
require_relative '../lib/item'


class ItemRepositoryTest < Minitest::Test
  def test_it_exist
    ir = ItemRepository.new
    assert_instance_of ItemRepository, ir
  end

  def test_it_starts_with_no_items
    ir = ItemRepository.new
    assert_equal [], ir.items
  end

  def test_can_add_a_item
    ir = ItemRepository.new
    i = Item.new({
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => BigDecimal.new(10.99,4),
      :created_at  => Time.now,
      :updated_at  => Time.now,
    })
    ir.add_item(i)
    assert_equal [i], ir.items
  end
end
