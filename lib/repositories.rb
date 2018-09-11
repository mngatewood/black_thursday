module Repositories

  def delete(id)
    x = find_by_id(id)
    @collection.delete(x)
  end

  def find_by_name(name)
    all.detect do |element|
      element.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name_fragment)
    matches = []
    all.each do |element|
      if element.name.downcase.include?(name_fragment.downcase)
        matches << element
      end
    end
    return matches
  end

  def find_all_with_description(description)
    matches = []
    all.each do |element|
      if element.description.downcase.include?(description.downcase)
        matches << element
      end
    end
    return matches
  end

  def all
    @collection
  end

  def find_all_by_merchant_id(merchant_id)
    all.find_all do |item|
      item.merchant_id.to_i == merchant_id
    end
  end

  def find_all_by_item_id(item_id)
    all.find_all do |item|
      item.item_id == item_id
    end
  end
end
