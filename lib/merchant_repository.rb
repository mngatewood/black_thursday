class MerchantRepository
  attr_reader :merchants

  def initialize
    @merchants = []
  end

  def add_merchant(merchant)
    @merchants << merchant
  end
end
