require 'time'
require_relative './repositories'

class CustomerRepository

  include Repositories

  attr_reader   :collection

  def initialize
    @collection = []
  end

  def find_all_by_first_name(first_name)
    collection.find_all do |element|
      element.first_name.downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    collection.find_all do |element|
      element.last_name.downcase.include?(last_name.downcase)
    end
  end
end
