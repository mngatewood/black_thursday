require 'pry'
require 'csv'
class SalesEngine
  attr_accessor :merchants

  def initialize
    @merchants = nil
  end

  def self.from_csv(repositories)
    se = SalesEngine.new
    mr = MerchantRepository.new
    file_path = repositories[:merchants]
    all_merchants = CSV.read(file_path, headers: true, header_converters: :symbol)
    all_merchants.each do |merchant|
      m = Merchant.new({:id => merchant[0], :name => merchant[1]})
      mr.add_merchant(m)
    end
    se.merchants = mr
    return se
  end
end
