require 'pry'
require 'time'
require_relative './repositories'

class InvoiceItemRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection = []
  end

  def add_item(invoice_item)
    @collection << @invoice_item
  end

end