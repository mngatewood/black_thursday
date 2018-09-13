module Repositories

  def inspect
    "#<#{self.class} #{@collection.size} rows>"
  end

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

  def find_all_by_invoice_id(invoice_id)
    collection.find_all{|element|element.invoice_id == invoice_id}
  end

  def find_by_id(id)
    @collection.find{|element|element.id == id}
  end

  def add_to_collection(object)
    @collection << object
  end

  def update_object_attributes(object, attributes, keys)
    if object
      keys.each do |key|
        value = attributes[key]
        object.send("#{key}=",value)
      end
      object.updated_at = Time.new
    end
  end

  def create(attributes)
    id = @collection.map{|element|element.id}.max + 1
    attributes[:id] = id
    object = create_object_of_type(attributes)
    add_to_collection(object)
  end

  def create_object_of_type(attributes)
    case @collection_type
    when "item" then Item.new(attributes)
    when "merchant" then Merchant.new(attributes)
    when "invoice item" then InvoiceItem.new(attributes)
    when "transaction" then Transaction.new(attributes)
# add new line for repository here
    end
  end

  def update(id, attributes)
    object = find_by_id(id)
    keys = attributes.keys
    invalid_keys = keys - get_valid_keys
    invalid_keys.length == 0 ?
      update_object_attributes(object, attributes, keys) :
      "Invalid key(s): #{invalid_keys.join(", ")}"
  end

  def get_valid_keys
    case @collection_type
    when "item" then [:name, :description, :unit_price]
    when "merchant" then [:name]
    when "invoice item" then [:quantity, :unit_price]
# add new line for repository here
    when "transaction" then [:credit_card_number, :credit_card_expiration_date, :result]
    end
  end

end
