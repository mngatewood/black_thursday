require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/customer'

class CustomerTest < Minitest::Test

  def setup
    @customer = Customer.new({
      :id => 6,
      :first_name => "Joan",
      :last_name => "Clarke",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
  end

  def test_it_exists
    assert_instance_of Customer, @customer
  end

  def test_it_has_attributes
    assert_equal 6, @customer.id
    assert_equal "Joan", @customer.first_name
    assert_equal "Clarke", @customer.last_name
    assert_equal "2018-09-10 00:00:00 -0600", @customer.created_at.to_s
    assert_equal "2018-09-11 00:00:00 -0600", @customer.updated_at.to_s
  end



end
