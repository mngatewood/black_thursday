require 'time'
require_relative './repositories'

class InvoiceItemRepository
  include Repositories

  attr_reader   :collection

  def initialize
    @collection = []
  end
end
