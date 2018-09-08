require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/merchant_repository'
require_relative '../lib/merchant'


class MerchantRepositoryTest < Minitest::Test
  def test_it_exist
    mr = MerchantRepository.new
    assert_instance_of MerchantRepository, mr
  end

  def test_it_starts_with_no_merchants
    mr = MerchantRepository.new
    assert_equal [], mr.merchants
  end

  def test_can_add_a_merchant
    mr = MerchantRepository.new
    m = Merchant.new({:id => 5, :name => "Turing School"})
    mr.add_merchant(m)
    assert_equal [m], mr.merchants
  end
end
