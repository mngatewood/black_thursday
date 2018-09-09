require 'pry'

class SalesAnalyst

  attr_reader :items,
              :merchants

  def initialize(sales_engine)
    @items      = sales_engine.items
    @merchants  = sales_engine.merchants
  end

  def average_items_per_merchant
    item_count = items.all.length.to_f
    merchant_count = merchants.all.length
    return (item_count / merchant_count).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    diff_from_mean = items_per_merchant.values.map{|items|items - mean}
    diff_squared = diff_from_mean.map{|difference|difference ** 2}
    sum_of_diff_squared = diff_squared.inject(0){|sum, diff|sum + diff}
    average_diff = sum_of_diff_squared / (merchants.all.length - 1)
    return Math.sqrt(average_diff).round(2)
  end

  def items_per_merchant
    merchant_ids = items.all.map{|item|item.merchant_id}
    item_counts = Hash.new(0)
    merchant_ids.each {|merchant_id|item_counts[merchant_id] += 1}
    return item_counts
  end

  def merchant_ids_with_high_item_count
    top_merchant_ids = []
    items_per_merchant.keys.each do |merchant_id|
      items = items_per_merchant[merchant_id]
      if items > average_items_per_merchant + average_items_per_merchant_standard_deviation
        top_merchant_ids << merchant_id
      end
    end
    return top_merchant_ids
  end

  def merchants_with_high_item_count
    top_merchants = []
    merchant_ids_with_high_item_count.map do |merchant_id|
      top_merchants << merchants.find_by_id(merchant_id)
    end
    return top_merchants
  end

end