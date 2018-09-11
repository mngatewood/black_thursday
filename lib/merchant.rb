class Merchant

  attr_reader   :id

  attr_accessor :name,
                :updated_at

  def initialize(info)
    @id = info[:id].to_i
    @name = info[:name]
    @updated_at   = info[:updated_at]
    @created_at   = info[:created_at]
  end
end
