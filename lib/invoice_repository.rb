require 'pry'
require 'time'
require_relative './repositories'

class InvoiceRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection_type = "invoice"
    @collection = []
  end

  def find_all_by_status(status)
    all.find_all do |item|
      item.status == status
    end
  end
end
