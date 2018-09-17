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
    !last_transaction ? false : last_transaction.result == :success
  end

  def invoice_total(invoice_id)
    invoice_items_array = invoice_items.find_all_by_invoice_id(invoice_id)
    invoice_amounts = invoice_items_array.map{|ii|ii.unit_price_to_dollars * ii.quantity.to_i}
    invoice_total = invoice_amounts.inject(0){|sum,ii|sum + ii}.round(2)
    return BigDecimal.new(invoice_total, invoice_total.to_s.length - 1)
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
      if invoices <= average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)
        bottom_merchant_ids << merchant_id
      end
      bottom_merchant_ids
    end
  end

  def bottom_merchants_by_invoice_count
    all_bottom_merchants = merchant_ids_with_low_invoice_count.inject([]) do |bottom_merchants, merchant_id|
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

  def total_revenue_by_date(date)
    all_invoices_on_date = invoices.collection.find_all do |invoice|
      date.to_s[0..9] == invoice.created_at.to_s[0..9]
    end
    return all_invoices_on_date.inject(0) do |sum, invoice|
      sum + invoice_total(invoice.id)
    end
  end

  def revenue_by_merchant(merchant_id)
    invoices_for_merchant = @invoices.find_all_by_merchant_id(merchant_id)
    invoices_for_merchant.inject(0) do |sum, invoice|
      invoice_paid_in_full?(invoice.id) && !pending_invoice?(invoice.id) && invoice.status != :returned ?
        sum + invoice_total(invoice.id) :
        sum
    end
  end

  def top_revenue_earners(x=20)
    sorted_merchants = sort_hash_by_value(all_merchants_total_revenue).reverse
    top_merchants_array = sorted_merchants.first(x)
    top_merchant_ids = top_merchants_array.map do |merchant_array|
      merchant_array[0]
    end
    top_merchants = top_merchant_ids.map do |id|
      @merchants.find_by_id(id)
    end
    return top_merchants
  end

  def all_merchants_total_revenue
    @merchants.collection.inject({}) do |merchant_revenue_total, merchant|
      merchant_revenue_total[merchant.id] = revenue_by_merchant(merchant.id)
      merchant_revenue_total
    end
  end

  def merchants_ranked_by_revenue
    sorted_merchant_revenue = sort_hash_by_value(all_merchants_total_revenue).reverse
    sorted_merchant_array = sorted_merchant_revenue.map do |merchant|
      merchants.find_by_id(merchant.first)
    end
  end

  def sort_hash_by_value(hash)
    hash.sort_by{|key, value|value}
  end

  def merchants_ids_with_pending_invoices
    invoices.collection.inject([]) do |merchant_id_array, invoice|
      if pending_invoice?(invoice.id)
        merchant_id_array << invoice.merchant_id
      end
      merchant_id_array
    end
  end

  def merchants_with_pending_invoices
    merchants_ids_with_pending_invoices.uniq.map do |merchant_id|
      merchants.find_by_id(merchant_id)
    end
  end

  def pending_invoice?(invoice_id)
    all_transactions_for_invoice(invoice_id).each do |t|
      if t.result == :success
        return false
      end
    end
    return true
  end

  def all_transactions_for_invoice(invoice_id)
    transactions.collection.find_all do |t|
      t.invoice_id == invoice_id
    end
  end

  def merchants_with_only_one_item
    merchant_ids_with_one_item = items_per_merchant.select do |merchant, item_count|
      item_count == 1
    end
    merchants_with_one_item = merchant_ids_with_one_item.keys.map do |merchant_id|
      merchants.find_by_id(merchant_id.to_i)
    end
  end

  def merchants_with_only_one_item_registered_in_month(month_name)
    invoice_found_in_given_month = invoices.collection.find_all do |invoice|
      invoice.created_at.strftime("%B") == month_name
    end
    invoices_with_merchants_created_in_the_same_month = invoice_found_in_given_month.find_all do |invoice|
      merchant = merchants.find_by_id(invoice.merchant_id)
      merchant.created_at.strftime("%B") == month_name
    end
    grouped_by_merchant_ids = invoices_with_merchants_created_in_the_same_month.group_by do |invoice|
      invoice.merchant_id
    end
    invoice_count = grouped_by_merchant_ids.keys.inject({}) do |hash, merchant_id|
      hash[merchant_id] = grouped_by_merchant_ids[merchant_id].length
      hash
    end
    merchant_id_count_pairs = invoice_count.find_all do |merchant_id, count|
      count == 1
    end
    merchants_with_one_invoice_in_month = merchant_id_count_pairs.map do |id_count_pair|
      merchants.find_by_id(id_count_pair[0])
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    invoices_filtered_by_merchant_id = invoices.collection.find_all do |invoice|
      invoice.merchant_id == merchant_id
    end

    max_items_hash = invoices_filtered_by_merchant_id.inject({}) do |hash, invoice|
      invoice_item_for_invoice = invoice_items.find_all_by_invoice_id(invoice.id)
      quantity_array = invoice_item_for_invoice.map do |invoice_item|
        invoice_item.quantity.to_i
      end
      max_invoice_item = invoice_item_for_invoice.find_all do |invoice_item|
        invoice_item.quantity.to_i == quantity_array.max
      end
      max_items_array = max_invoice_item.map do |invoice_item|
        items.find_by_id(invoice_item.item_id)
      end
      hash[max_items_array] = quantity_array.max
      hash
    end

    max_items_for_merchant = max_items_hash.find_all do |items, quantity|
      quantity == max_items_hash.values.max
    end
    binding.pry
  end
end
