require 'pry'

class SalesAnalyst

  attr_reader :items,
              :merchants,
              :invoice_items,
              :invoices

  def initialize(items, merchants, invoice_items, invoices)
    @items          = items
    @merchants      = merchants
    @invoice_items  = invoice_items
    @invoices       = invoices
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

  def average_invoices_per_merchant
    return (invoices.all.length.to_f / merchants.all.length).round(2)
  end

  def invoices_per_merchant
    merchant_ids = invoices.all.map{|invoice|invoice.merchant_id}
    merchant_ids.inject(Hash.new(0)) do |invoice_counts, merchant_id|
      invoice_counts[merchant_id] += 1
      invoice_counts
    end
  end

  def average_invoices_per_merchant_standard_deviation
    array_of_invoices_counts = invoices.all.map{|invoice|invoice.id}
    mean = average_invoices_per_merchant
    diff_from_mean = invoices_per_merchant.values.map{|invoices|invoices - mean}
    diff_squared = diff_from_mean.map{|difference|difference ** 2}
    sum_of_diff_squared = diff_squared.inject(0){|sum, diff|sum + diff}
    average_diff = sum_of_diff_squared / (merchants.all.length - 1)
    return Math.sqrt(average_diff).round(2)
  end

  def merchant_ids_with_high_invoice_count
    invoices_per_merchant.keys.inject([]) do |top_merchant_ids, merchant_id|
      invoices = invoices_per_merchant[merchant_id]
      if invoices > average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2)
        top_merchant_ids << merchant_id
      end
      top_merchant_ids
    end
  end

  def top_merchants_by_invoice_count
    all_top_merchants = merchant_ids_with_high_invoice_count.inject([]) do |top_merchants, merchant_id|
      top_merchants << merchants.find_by_id(merchant_id.to_i)
    end
    all_top_merchants
  end

  def merchant_ids_with_low_invoice_count
    invoices_per_merchant.keys.inject([]) do |bottom_merchant_ids, merchant_id|
      invoices = invoices_per_merchant[merchant_id]
      if invoices < average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)
        bottom_merchant_ids << merchant_id
      end
      bottom_merchant_ids
    end
  end

  def bottom_merchants_by_invoice_count
    all_bottom_merchants = merchant_ids_with_high_invoice_count.inject([]) do |bottom_merchants, merchant_id|
      bottom_merchants << merchants.find_by_id(merchant_id.to_i)
    end
    all_bottom_merchants
  end

  def average_invoices_per_day_standard_deviation(invoices_per_day_array)
    mean = @invoices.all.count/7
    diff_from_mean = invoices_per_day_array.map{|invoice_count|invoice_count - mean}
    diff_squared = diff_from_mean.map{|difference|difference ** 2}
    sum_of_diff_squared = diff_squared.inject(0){|sum, diff|sum + diff}
    average_diff = sum_of_diff_squared / (invoices_per_day_array.length - 1)
    return Math.sqrt(average_diff)
  end

  def top_days_by_invoice_count
    average_invoices_per_day = @invoices.all.count/7
    grouped_by_weekday = @invoices.all.group_by do |invoice|
      invoice.created_at.wday
    end
    invoices_by_day = grouped_by_weekday.values.map do |invoices|
      invoices.count
    end
    day_nums = grouped_by_weekday.find_all do |weekday, invoices|
      invoices.count > average_invoices_per_day + average_invoices_per_day_standard_deviation(invoices_by_day)
    end.to_h.keys
    day_nums.map do |daynumber|
      Date::DAYNAMES[daynumber]
    end
  end

  def invoice_status(status_sym)
    status = status_sym
    grouped_by_status = @invoices.all.group_by do |invoice|
      invoice.status
    end
    (((grouped_by_status[status].count.to_f)/(@invoices.all.count)) * 100).round(2)
  end
end
