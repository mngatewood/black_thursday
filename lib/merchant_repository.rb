require 'pry'
require_relative './repositories'

class MerchantRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection = []
    @collection_type = "merchant"
  end

  def inspect
    "#<#{self.class} #{@collection.size} rows>"
  end

end
