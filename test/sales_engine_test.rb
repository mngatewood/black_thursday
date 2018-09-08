require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/merchant_repository'
require_relative '../lib/merchant'


class SalesEngineTest < Minitest::Test
  def test_it_exist
    se = SalesEngine.new
    assert_instance_of SalesEngine, se
  end

  def test_creates_instance_of_merchant_repository
    se_t = SalesEngine.from_csv({
    :merchants => "./data/merchants.csv",
    })

    assert_instance_of MerchantRepository, se_t.merchants
  end
end
