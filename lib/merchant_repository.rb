require_relative './repositories'

class MerchantRepository
  include Repositories

  attr_reader :collection

  def initialize
    @collection = []
  end
end
