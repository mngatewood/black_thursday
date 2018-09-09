class SalesAnalyst

  attr_reader :items,
              :merchants

  def initialize(sales_engine)
    @items      = sales_engine.items
    @merchants  = sales_engine.merchants
  end

end