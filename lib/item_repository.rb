class ItemRepository
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(item)
    @items << item
  end

  def all
    items
  end

  def find_by_id(id)
    items.find{|item|item.id == id}
  end

  def find_by_name(name)
    items.find{|item|item.name.downcase == name.downcase}
  end

end
