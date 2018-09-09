require 'pry'

class SalesAnalyst

  attr_reader :items,
              :merchants

  def initialize(sales_engine)
    @items      = sales_engine.items.items
    @merchants  = sales_engine.merchants.merchants
  end

  def average_items_per_merchant
    item_count = items.length.to_f
    merchant_count = merchants.length
    return (item_count / merchant_count).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    diff_from_mean = items_per_merchant.values.map{|items|items - mean}
    diff_squared = diff_from_mean.map{|difference|difference ** 2}
    sum_of_diff_squared = diff_squared.inject(0){|sum, diff|sum + diff}
    average_diff = sum_of_diff_squared / (merchants.length - 1)
    return Math.sqrt(average_diff).round(2)
  end

  def items_per_merchant
    merchant_ids = items.map{|item|item.merchant_id}
    item_counts = Hash.new(0)
    merchant_ids.each {|merchant_id|item_counts[merchant_id] += 1}
    return item_counts
  end

end