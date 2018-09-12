# require 'minitest/autorun'
# require 'minitest/pride'
# require 'bigdecimal'
# require 'time'
# require_relative '../lib/invoice_item_repository'
# require_relative '../lib/invoice_item'
#
# class InvoiceItemRepositoryTest < Minitest::Test
#
#   def setup
#     @iir = InvoiceItemRepository.new
#     @invoice_item_1 = InvoiceItem.new({
#       :id => 6,
#       :item_id => 7,
#       :invoice_id => 8,
#       :quantity => 1,
#       :unit_price => BigDecimal.new(10.99, 4),
#       :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
#       :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
#       })
#   end
#
#   def test_it_exist
#     assert_instance_of InvoiceItemRepository, @iir
#   end
#
#   def test_it_starts_with_no_invoice_items
#     assert_equal [], @iir.collection
#   end
#
#   def test_can_add_a_single_invoice_item
#     @iir.add_item(@invoice_item_1)
#     assert_equal [@invoice_item_1], @ir.collection
#   end
#
# end
