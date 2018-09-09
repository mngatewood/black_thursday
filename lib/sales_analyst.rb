require 'pry'

class SalesAnalyst

  attr_reader :items,
              :merchants

  def initialize(sales_engine)
    @items      = sales_engine.items.items
    @merchants  = sales_engine.merchants.merchants
  end

  def average_items_per_merchant
    item_count = @items.length.to_f
    merchant_count = @merchants.length
    return (item_count / merchant_count).round(2)
  end

end