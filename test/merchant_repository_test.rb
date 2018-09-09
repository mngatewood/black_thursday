require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repository'
require_relative '../lib/merchant'


class MerchantRepositoryTest < Minitest::Test

  def setup
    @mr = MerchantRepository.new
    @merchant_1 = Merchant.new({:id => 1, :name => "Shopin1901"})
    @merchant_2 = Merchant.new({:id => 2, :name => "Candisart"})
    @merchant_3 = Merchant.new({:id => 3, :name => "Not Candy Crack"})
    @merchant_4 = Merchant.new({:id => 4, :name => "LolaMarleys"})
    @merchant_5 = Merchant.new({:id => 5, :name => "Turing School"})
  end

  def add_test_merchants
    @mr.add_merchant(@merchant_1)
    @mr.add_merchant(@merchant_2)
    @mr.add_merchant(@merchant_3)
    @mr.add_merchant(@merchant_4)
    @mr.add_merchant(@merchant_5)
  end

  def test_it_exist
    assert_instance_of MerchantRepository, @mr
  end

  def test_it_starts_with_no_merchants
    assert_equal [], @mr.merchants
  end

  def test_can_add_a_merchant
    m = Merchant.new({:id => 5, :name => "Turing School"})
    @mr.add_merchant(m)
    assert_equal [m], @mr.merchants
  end

  def test_can_add_several_merchants
    @mr.add_merchant(@merchant_1)
    @mr.add_merchant(@merchant_2)
    @mr.add_merchant(@merchant_3)
    @mr.add_merchant(@merchant_4)
    @mr.add_merchant(@merchant_5)
    expected = [@merchant_1, @merchant_2, @merchant_3, @merchant_4, @merchant_5]
    assert_equal expected, @mr.merchants
  end

  def test_it_can_return_all_merchants
    self.add_test_merchants
    expected = [@merchant_1, @merchant_2, @merchant_3, @merchant_4, @merchant_5]
    assert_equal expected, @merchant_repository.all
  end

  def test_it_can_find_a_merchant_by_id
    self.add_test_merchants
    assert_equal @merchant_repository.find_by_id(1), @merchant_1
    assert_nil @merchant_repository.find_by_id(0)

  end
  
  def test_it_can_find_a_single_merchant_by_name
    self.add_test_merchants
    assert_equal @merchant_2, @merchant_repository.find_by_name("Candisart")
    assert_nil @merchant_repository.find_by_name("Not A Real Merchant")
  end
  
  def test_it_can_find_all_merchants_by_partial_name
    self.add_test_merchants
    expected = [@merchant_2, @merchant_3]
    assert_equal expected, @merchant_repository.find_all_by_name("cand")
    assert_equal [], @merchant_repository.find_all_by_name("notgonnafindit")
  end

  def test_it_can_create_a_new_merchant
    self.add_test_merchants
    attributes = {:name => "Nerds Inc."}
    @merchant_repository.create(attributes)
    assert_equal 6, @merchant_repository.merchants.last.id
    assert_equal "Nerds Inc.", @merchant_repository.merchants.last.name
  end

  def test_it_can_update_merchant_attributes
    self.add_test_merchants
    attributes = {:name => "Candy For Adults"}
    @merchant_repository.update(3, attributes)
    assert_equal "Candy For Adults", @merchant_repository.find_by_id(3).name
  end

  def test_it_can_delete_a_merchant_by_id
    self.add_test_merchants
    @merchant_repository.delete(1)
    assert_nil @merchant_repository.find_by_id(1)
    assert_nil @merchant_repository.find_by_name("Shopin1901")
  end
  
end
