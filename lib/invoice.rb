class Invoice
  attr_reader   :id,
                :created_at,
                :merchant_id,
                :customer_id,
                :status

  attr_accessor :updated_at

  def initialize(info)
    @id           = info[:id].to_i
    @created_at   = info[:created_at]
    @updated_at   = info[:updated_at]
    @merchant_id  = info[:merchant_id]
    @customer_id  = info[:customer_id]
    @status       = info[:status]
  end
end
