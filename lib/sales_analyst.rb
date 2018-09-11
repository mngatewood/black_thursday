require 'pry'

class SalesAnalyst

  attr_reader :items,
              :merchants

  def initialize(items, merchants)
    @items      = items
    @merchants  = merchants
  end

  def inspect
    "#<#{self.class} #{@collection.size} rows>"
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
      top_merchants << merchants.find_by_id(merchant_id.to_i)
    end
    return top_merchants
  end
  
  def average_item_price_for_merchant(merchant_id)
    all_items_for_merchant = items.all.find_all{|item|item.merchant_id == merchant_id.to_s}
    all_prices = all_items_for_merchant.map{|item|item.unit_price}
    total_all_prices = all_prices.inject(0){|sum, price|sum + price}
    return (total_all_prices / all_items_for_merchant.length).round(2)
  end

  def average_average_price_per_merchant
    sum_of_averages = merchants.all.inject(0) do |sum, merchant|
      sum + average_item_price_for_merchant(merchant.id.to_s)
    end
    return (sum_of_averages / merchants.all.length).round(2)
  end

  def average_item_price
    array_of_prices = items.all.map{|item|item.unit_price}
    sum_of_prices = array_of_prices.inject(0){|sum, price|sum + price}
    return sum_of_prices / items.all.length
  end

  def average_item_price_standard_deviation
    mean = average_item_price
    all_prices = items.all.map{|item|item.unit_price}
    diff_from_mean = all_prices.map{|items|items - mean}
    diff_squared = diff_from_mean.map{|difference|difference ** 2}
    sum_of_diff_squared = diff_squared.inject(0){|sum, diff|sum + diff}
    average_diff = sum_of_diff_squared / (items.all.length - 1)
    standard_deviation = Math.sqrt(average_diff)
    return BigDecimal.new(standard_deviation, standard_deviation.to_i.to_s.length + 2)
  end

  def golden_items
    threshold = average_item_price + average_item_price_standard_deviation * 2
    return items.all.find_all{|item|item.unit_price > threshold}
  end

end
