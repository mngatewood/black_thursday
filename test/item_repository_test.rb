require 'minitest/autorun'
require 'minitest/pride'
require 'bigdecimal'
require 'time'
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
                        :unit_price => BigDecimal.new(10.99,4),
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

  def test_it_can_find_all_items_by_price
    self.add_test_items
    expected = [@item_1, @item_3]
    assert_equal expected, @ir.find_all_by_price(10.99)
    assert_equal [], @ir.find_all_by_price(14.99)
  end

  def test_it_can_find_all_items_within_price_range
    self.add_test_items
    expected = [@item_1, @item_2, @item_3]
    assert_equal expected, @ir.find_all_by_price_in_range(10..20)
    assert_equal [], @ir.find_all_by_price_in_range(20..50)
  end

  def test_it_can_find_all_items_by_merchant_id
    self.add_test_items
    expected = [@item_1, @item_2]
    assert_equal expected, @ir.find_all_by_merchant_id(2)
    assert_equal [], @ir.find_all_by_merchant_id(0)
  end

  def test_it_can_create_a_new_item
    self.add_test_items
    attributes = {:name => "Keyboard",
                  :description => "You can use it to type things",
                  :unit_price => BigDecimal.new(59.99,4),
                  :created_at => Time.new(2018, 9, 8, 0, 0, 0, "-06:00"),
                  :updated_at => Time.new(2018, 9, 9, 0, 0, 0, "-06:00"),
                  :merchant_id => 2
                  }
    @ir.create(attributes)
    item = @ir.items.last
    assert_equal 6, item.id
    assert_equal "Keyboard", item.name
    assert_equal "You can use it to type things", item.description
    assert_equal BigDecimal.new(59.99,4), item.unit_price
    assert_equal "2018-09-08 00:00:00 -0600", item.created_at.to_s
    assert_equal "2018-09-09 00:00:00 -0600", item.updated_at.to_s
    assert_equal 2, item.merchant_id
  end

  def test_it_can_update_item_attributes
    self.add_test_items
    attributes = {:name => "Mechanical Pencil",
                  :description => "It's a pencil you don't have to sharpen",
                  :unit_price => BigDecimal.new(4.99,4),
                  }
    @ir.update(1, attributes)
    item = @ir.find_by_id(1)
    assert_equal "Mechanical Pencil", item.name
    assert_equal "It's a pencil you don't have to sharpen", item.description
    assert_equal  BigDecimal.new(4.99,4), item.unit_price
    assert_equal  "2018-09-10 00:00:00 -0600", item.updated_at.to_s

    attributes = {:name => "Paper",
                  :weight => "20lb",
                  :merchant_id => 9
                  }
    item = @ir.find_by_id(2)
    assert_equal "Invalid key(s): weight, merchant_id", @ir.update(2, attributes)

  end

  def test_it_can_delete_an_item_by_id
    self.add_test_items
    @ir.delete(1)
    assert_nil @ir.find_by_id(1)
    assert_nil @ir.find_by_name("Pencil")
  end

end
