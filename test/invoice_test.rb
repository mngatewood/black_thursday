require_relative './helper_test'
require 'bigdecimal'
require 'time'
require_relative '../lib/invoice'

class InvoiceTest < Minitest::Test

  def setup
    @i = Invoice.new({
        :id          => 6,
        :customer_id => 7,
        :merchant_id => 8,
        :status      => "pending",
        :created_at => Time.new(2018, 9, 8, 0, 0, 0, "-06:00"),
        :updated_at => Time.new(2018, 9, 9, 0, 0, 0, "-06:00")
        })
  end

  def test_it_exist
    assert_instance_of Invoice, @i
  end

  def test_it_has_attributes
    assert_equal 6, @i.id
    assert_equal 8, @i.merchant_id
    assert_equal 7, @i.customer_id
    assert_equal "pending", @i.status
    assert_equal "2018-09-08 00:00:00 -0600", @i.created_at.to_s
    assert_equal "2018-09-09 00:00:00 -0600", @i.updated_at.to_s
  end
end
