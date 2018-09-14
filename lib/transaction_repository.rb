require 'pry'
require 'time'
require_relative './repositories'

class TransactionRepository

  include Repositories

  attr_reader   :collection

  def initialize
    @collection       = []
  end

  def find_all_by_credit_card_number(credit_card_number)
    collection.find_all{|element|element.credit_card_number == credit_card_number}
  end

  def find_all_by_result(result)
    collection.find_all{|element|element.result == result}
  end



end