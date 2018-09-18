require_relative './helper_test'
require 'time'
require_relative '../lib/customer_repository'
require_relative '../lib/customer'

class CustomerRepositoryTest < Minitest::Test

  def setup
    @cr = CustomerRepository.new
    @customer_1 = Customer.new({
      :id => 6,
      :first_name => "Joan",
      :last_name => "Clarke",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @customer_2 = Customer.new({
      :id => 7,
      :first_name => "Alan",
      :last_name => "Turing",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @customer_3 = Customer.new({
      :id => 8,
      :first_name => "Michael",
      :last_name => "Gatewood",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @customer_4 = Customer.new({
      :id => 9,
      :first_name => "Isaac",
      :last_name => "Falkenstine",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @customer_5 = Customer.new({
      :id => 10,
      :first_name => "Alan",
      :last_name => "Clarke",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
  end

  def add_test_customers
    @cr.add_to_collection(@customer_1)
    @cr.add_to_collection(@customer_2)
    @cr.add_to_collection(@customer_3)
    @cr.add_to_collection(@customer_4)
    @cr.add_to_collection(@customer_5)
  end

  def test_it_exists
    assert_instance_of CustomerRepository, @cr
  end

  def test_it_starts_with_no_customers
    assert_equal [], @cr.collection
  end

  def test_can_add_a_single_customer
    @cr.add_to_collection(@customer_1)
    assert_equal [@customer_1], @cr.collection
  end

  def test_it_can_add_several_customers
    @cr.add_to_collection(@customer_1)
    @cr.add_to_collection(@customer_2)
    @cr.add_to_collection(@customer_3)
    @cr.add_to_collection(@customer_4)
    @cr.add_to_collection(@customer_5)
    expected = [@customer_1, @customer_2, @customer_3, @customer_4, @customer_5]
    assert_equal expected, @cr.collection
  end

  def test_it_can_return_all_customers
    self.add_test_customers
    expected = [@customer_1, @customer_2, @customer_3, @customer_4, @customer_5]
    assert_equal expected, @cr.all
  end

  def test_it_can_find_a_customer_by_id
    self.add_test_customers
    assert_equal @customer_1, @cr.find_by_id(6)
    assert_nil @cr.find_by_id(0)
  end

  def test_it_can_find_all_customers_by_first_name
    self.add_test_customers
    expected = [@customer_2, @customer_5]
    assert_equal expected, @cr.find_all_by_first_name("Alan")
    assert_equal [], @cr.find_all_by_first_name("David")
  end

  def test_it_can_find_all_customers_by_last_name
    self.add_test_customers
    expected = [@customer_1, @customer_5]
    assert_equal expected, @cr.find_all_by_last_name("Clarke")
    assert_equal [], @cr.find_all_by_last_name("David")
  end

  def test_it_can_create_a_new_customer
    self.add_test_customers
    attributes = {
      :first_name => "John",
      :last_name => "Smith",
      :created_at => Time.new(2018, 9, 12, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 13, 0, 0, 0, "-06:00")
    }
    @cr.create(attributes)
    customer = @cr.collection.last
    assert_equal 11, customer.id
    assert_equal "John", customer.first_name
    assert_equal "Smith", customer.last_name
    assert_equal "2018-09-12 00:00:00 -0600", customer.created_at.to_s
    assert_equal "2018-09-13 00:00:00 -0600", customer.updated_at.to_s
  end

  def test_it_can_update_customer_attributes
    self.add_test_customers
    attributes = {
      :first_name => "Joanne",
      :last_name => "Adams",
      }
    customer = @cr.find_by_id(10)
    original_udpated_at = customer.updated_at
    @cr.update(10, attributes)
    assert_equal "Joanne", customer.first_name
    assert_equal "Adams", customer.last_name
    refute_equal original_udpated_at, customer.updated_at

    attributes = {:id => 1,
                  :created_at => Time.new(2018, 9, 12, 0, 0, 0, "-06:00")
                  }
    assert_equal "Invalid key(s): id, created_at", @cr.update(6, attributes)
  end

  def test_it_can_delete_a_customer_by_id
    self.add_test_customers
    @cr.delete(6)
    assert_nil @cr.find_by_id(6)
  end

end
