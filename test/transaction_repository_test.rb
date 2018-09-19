require_relative './helper_test'
require 'time'
require_relative '../lib/transaction_repository'
require_relative '../lib/transaction'

class TransactionRepositoryTest < Minitest::Test

  def setup
    @tr = TransactionRepository.new
    @transaction_1 = Transaction.new({
      :id => 6,
      :invoice_id => 8,
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date => "0220",
      :result => "success",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @transaction_2 = Transaction.new({
      :id => 7,
      :invoice_id => 8,
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date => "0220",
      :result => "success",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @transaction_3 = Transaction.new({
      :id => 8,
      :invoice_id => 8,
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date => "0220",
      :result => "success",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @transaction_4 = Transaction.new({
      :id => 9,
      :invoice_id => 9,
      :credit_card_number => "4646464646464646",
      :credit_card_expiration_date => "0221",
      :result => "success",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
    @transaction_5 = Transaction.new({
      :id => 10,
      :invoice_id => 10,
      :credit_card_number => "4646464646464646",
      :credit_card_expiration_date => "0221",
      :result => "failure",
      :created_at => Time.new(2018, 9, 10, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 11, 0, 0, 0, "-06:00")
    })
  end

  def add_test_transactions
    @tr.add_to_collection(@transaction_1)
    @tr.add_to_collection(@transaction_2)
    @tr.add_to_collection(@transaction_3)
    @tr.add_to_collection(@transaction_4)
    @tr.add_to_collection(@transaction_5)
  end

  def test_it_exists
    assert_instance_of TransactionRepository, @tr
  end

  def test_it_starts_with_no_transactions
    assert_equal [], @tr.collection
  end

  def test_can_add_a_single_transaction
    @tr.add_to_collection(@transaction_1)
    assert_equal [@transaction_1], @tr.collection
  end

  def test_it_can_add_several_transactions
    @tr.add_to_collection(@transaction_1)
    @tr.add_to_collection(@transaction_2)
    @tr.add_to_collection(@transaction_3)
    @tr.add_to_collection(@transaction_4)
    @tr.add_to_collection(@transaction_5)
    expected = [@transaction_1, @transaction_2, @transaction_3, @transaction_4, @transaction_5]
    assert_equal expected, @tr.collection
  end

  def test_it_can_return_all_transactions
    self.add_test_transactions
    expected = [@transaction_1, @transaction_2, @transaction_3, @transaction_4, @transaction_5]
    assert_equal expected, @tr.all
  end

  def test_it_can_find_a_transaction_by_id
    self.add_test_transactions
    assert_equal @transaction_1, @tr.find_by_id(6)
    assert_nil @tr.find_by_id(0)
  end

  def test_it_can_find_all_transactions_by_invoice_id
    self.add_test_transactions
    expected = [@transaction_1, @transaction_2, @transaction_3]
    assert_equal expected, @tr.find_all_by_invoice_id(8)
    assert_equal [], @tr.find_all_by_invoice_id(0)
  end

  def test_it_can_find_all_transactions_by_credit_card_number
    self.add_test_transactions
    expected = [@transaction_4, @transaction_5]
    assert_equal expected, @tr.find_all_by_credit_card_number("4646464646464646")
    assert_equal [], @tr.find_all_by_credit_card_number("1212121212121212")
  end

  def test_it_can_find_all_transactions_by_result
    self.add_test_transactions
    expected = [@transaction_1, @transaction_2, @transaction_3, @transaction_4]
    assert_equal expected, @tr.find_all_by_result("success")
    assert_equal [@transaction_5], @tr.find_all_by_result("failure")
    assert_equal [], @tr.find_all_by_result("error")
  end

  def test_it_can_create_a_new_transaction
    self.add_test_transactions
    attributes = {
      :invoice_id => 12,
      :credit_card_number => "4545454545454545",
      :credit_card_expiration_date => "0222",
      :result => "success",
      :created_at => Time.new(2018, 9, 12, 0, 0, 0, "-06:00"),
      :updated_at => Time.new(2018, 9, 13, 0, 0, 0, "-06:00")
    }
    @tr.create(attributes)
    transaction = @tr.collection.last
    assert_equal 11, transaction.id
    assert_equal 12, transaction.invoice_id
    assert_equal "4545454545454545", transaction.credit_card_number
    assert_equal "0222", transaction.credit_card_expiration_date
    assert_equal "success", transaction.result
    assert_equal "2018-09-12 00:00:00 -0600", transaction.created_at.to_s
    assert_equal "2018-09-13 00:00:00 -0600", transaction.updated_at.to_s
  end

  def test_it_can_update_transaction_attributes
    self.add_test_transactions
    attributes = {
      :credit_card_number => "4646464646464646",
      :credit_card_expiration_date => "0222",
      :result => "success"
      }
    transaction = @tr.find_by_id(10)
    original_udpated_at = transaction.updated_at
    @tr.update(10, attributes)
    assert_equal "4646464646464646", transaction.credit_card_number
    assert_equal "0222", transaction.credit_card_expiration_date
    assert_equal "success", transaction.result
    refute_equal original_udpated_at, transaction.updated_at

    attributes = {:item_id => 7,
                  :merchant_id => 9
                  }
    assert_equal "Invalid key(s): item_id, merchant_id", @tr.update(11, attributes)
  end

  def test_it_can_delete_a_transaction_by_id
    self.add_test_transactions
    @tr.delete(6)
    assert_nil @tr.find_by_id(6)
  end
end
