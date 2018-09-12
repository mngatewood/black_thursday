require 'pry'
require 'time'
require_relative './repositories'

class InvoiceItemRepository
  include Repositories

  attr_reader   :collection

  attr_accessor :quantity,
                :unit_price,
                :updated_at

  def initialize
    @collection       = []
    @collection_type  = "invoice item"
  end

  def find_all_by_invoice_id(invoice_id)
    collection.find_all{|element|element.invoice_id == invoice_id}
  end

end