require 'pry'

class SalesAnalyst

  attr_reader :items,
              :merchants,
              :invoice_items,
              :invoices,
              :transactions,
              :customers

  def initialize(items, merchants, invoice_items, invoices, transactions, customers)
    @items          = items
    @merchants      = merchants
    @invoice_items  = invoice_items
    @invoices       = invoices
    @transactions   = transactions
    @customers      = customers
  end

  def inspect
    "#<#{self.class} #{@collection.size} rows>"
  end

  def average_items_per_merchant
    return (items.all.length.to_f / merchants.all.length).round(2)
  end

  def average_items_per_merchant_standard_deviation
    array_of_item_counts = items.all.map{|item|item.unit_price}
    mean = average_items_per_merchant
    diff_from_mean = items_per_merchant.values.map{|items|items - mean}
    diff_squared = diff_from_mean.map{|difference|difference ** 2}
    sum_of_diff_squared = diff_squared.inject(0){|sum, diff|sum + diff}
    average_diff = sum_of_diff_squared / (merchants.all.length - 1)
    return Math.sqrt(average_diff).round(2)
  end

  def items_per_merchant
    merchant_ids = items.all.map{|item|item.merchant_id}
    merchant_ids.inject(Hash.new(0)) do |item_counts, merchant_id|
      item_counts[merchant_id] += 1
      item_counts
    end
  end

  def merchant_ids_with_high_item_count
    items_per_merchant.keys.inject([]) do |top_merchant_ids, merchant_id|
      items = items_per_merchant[merchant_id]
      if items > average_items_per_merchant + average_items_per_merchant_standard_deviation
        top_merchant_ids << merchant_id
      end
      top_merchant_ids
    end
  end

  def merchants_with_high_item_count
    merchant_ids_with_high_item_count.inject([]) do |top_merchants, merchant_id|
      top_merchants << merchants.find_by_id(merchant_id.to_i)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    all_items_for_merchant = items.all.find_all{|item|item.merchant_id == merchant_id.to_s}
    array_of_prices = all_items_for_merchant.map{|item|item.unit_price}
    return average(array_of_prices)
  end

  def average_average_price_per_merchant
    sum_of_averages = merchants.all.inject(0) do |sum, merchant|
      sum + average_item_price_for_merchant(merchant.id.to_s)
    end
    return (sum_of_averages / merchants.all.length).round(2)
  end

  def average_item_price
    array_of_prices = items.all.map{|item|item.unit_price}
    return average(array_of_prices)
  end

  def average_item_price_standard_deviation
    array_of_prices = items.all.map{|item|item.unit_price}
    return standard_deviation(array_of_prices)
  end

  def average(array)
    sum_of_elements = array.inject(0){|sum, element|sum + element}
    return (sum_of_elements / array.length).round(2)
  end

  def standard_deviation(array)
    mean = average(array)
    diff_from_mean = array.map{|element|element - mean}
    diff_squared = diff_from_mean.map{|difference|difference ** 2}
    sum_of_diff_squared = diff_squared.inject(0){|sum, diff|sum + diff}
    average_diff = sum_of_diff_squared / (items.all.length - 1)
    standard_deviation = Math.sqrt(average_diff)
    standard_deviation_length = standard_deviation.to_i.to_s.length + 2
    return BigDecimal.new(standard_deviation, standard_deviation_length)
  end

  def golden_items
    threshold = average_item_price + average_item_price_standard_deviation * 2
    return items.all.find_all{|item|item.unit_price > threshold}
  end

  def invoice_paid_in_full?(invoice_id)
    invoice_transactions = transactions.find_all_by_invoice_id(invoice_id)
    last_transaction = invoice_transactions.sort_by{|t|t.updated_at}.last
    last_transaction.result == :success
  end

end
