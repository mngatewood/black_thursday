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

  def create(attributes)
    id = @collection.map{|item|item.id}.max + 1
    attributes[:id] = id
    invoice = Invoice.new(attributes)
    add_to_collection(invoice)
  end

  def update(id, attributes)
    invoice = find_by_id(id)
    keys = attributes.keys
    valid_keys = [:name]
    invalid_keys = keys - valid_keys
    invalid_keys.length == 0 ?
      update_object_attributes(invoice, attributes, keys) :
      "Invalid key(s): #{invalid_keys.join(", ")}"
  end

end
