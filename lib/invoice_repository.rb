require 'time'
require_relative './repositories'

class InvoiceRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection = []
  end

  def find_all_by_status(status)
    collection.find_all do |item|
      item.status == status
    end
  end
end
