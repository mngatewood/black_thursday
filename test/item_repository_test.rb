require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require_relative '../lib/item_repository'
require_relative '../lib/item'


class ItemRepositoryTest < Minitest::Test

  def setup
    @ir = ItemRepository.new
    @item_1 = Item.new({:id => 1, 
                        :name => "Pencil",
                        :description => "You can use it to write things",
                        :unit_price => BigDecimal.new(10.99,4),
                        :created_at => Time.now,
                        :updated_at => Time.now,
                        :merchant_id => 2
                      })
    @item_2 = Item.new({:id => 2, 
                        :name => "Paper",
                        :description => "You can write things on it",
                        :unit_price => BigDecimal.new(19.99,4),
                        :created_at => Time.now,
                        :updated_at => Time.now,
                        :merchant_id => 2
                      })
    @item_3 = Item.new({:id => 3, 
                        :name => "Book",
                        :description => "You can write about it",
                        :unit_price => BigDecimal.new(14.99,4),
                        :created_at => Time.now,
                        :updated_at => Time.now,
                        :merchant_id => 3
                      })
    @item_4 = Item.new({:id => 4, 
                        :name => "Eraser",
                        :description => "You can use it to erase the things you write",
                        :unit_price => BigDecimal.new(1.99,4),
                        :created_at => Time.now,
                        :updated_at => Time.now,
                        :merchant_id => 4
                      })
    @item_5 = Item.new({:id => 5, 
                        :name => "Book Shelf",
                        :description => "You can use it hold all the books you write",
                        :unit_price => BigDecimal.new(99.99,4),
                        :created_at => Time.now,
                        :updated_at => Time.now,
                        :merchant_id => 5
                      })
  end

  def add_test_items
    @ir.add_item(@item_1)
    @ir.add_item(@item_2)
    @ir.add_item(@item_3)
    @ir.add_item(@item_4)
    @ir.add_item(@item_5)
  end

  def test_it_exist
    ir = ItemRepository.new
    assert_instance_of ItemRepository, ir
  end

  def test_it_starts_with_no_items
    ir = ItemRepository.new
    assert_equal [], ir.items
  end

  def test_can_add_a_single_item
    @ir.add_item(@item_1)
    assert_equal [@item_1], @ir.items
  end

  def test_it_can_add_several_items
    @ir.add_item(@item_1)
    @ir.add_item(@item_2)
    @ir.add_item(@item_3)
    @ir.add_item(@item_4)
    @ir.add_item(@item_5)
    expected = [@item_1, @item_2, @item_3, @item_4, @item_5]
    assert_equal expected, @ir.items
  end

  def test_it_can_return_all_items
    self.add_test_items
    expected = [@item_1, @item_2, @item_3, @item_4, @item_5]
    assert_equal expected, @ir.all
  end

  def test_it_can_find_a_item_by_id
    self.add_test_items
    assert_equal @ir.find_by_id(1), @item_1
    assert_nil @ir.find_by_id(0)

  end
  
  def test_it_can_find_a_single_item_by_name
    self.add_test_items
    assert_equal @item_2, @ir.find_by_name("Paper")
    assert_nil @ir.find_by_name("Not A Real Item")
  end
  
  def test_it_can_find_all_items_by_partial_description
    self.add_test_items
    expected = [@item_1, @item_2, @item_4]
    assert_equal expected, @ir.find_all_with_description("things")
    assert_equal [], @ir.find_all_with_description("notgonnafindit")
  end



end
