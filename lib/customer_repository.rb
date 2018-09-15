require 'pry'
require 'time'
require_relative './repositories'

class CustomerRepository

  include Repositories

  attr_reader   :collection

  def initialize
    @collection       = []
  end

  def find_all_by_first_name(first_name)
    collection.find_all{|element|element.first_name == first_name}
  end

  def find_all_by_last_name(last_name)
    collection.find_all{|element|element.last_name == last_name}
  end

end
