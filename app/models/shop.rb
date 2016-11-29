class Shop < ActiveRecord::Base
    
    has_many :houses, through: :shops_houses
    has_many :shops_houses, class_name: "ShopssHouses"
    
    def self.to_csv
    attributes = %w{id name distance latitude longitude}
    
    CSV.generate(headers: true) do |csv|
    csv << attributes
    Shop.all.each do |shop|
    csv << attributes.map { |attr| shop.send(attr) }
end
end
end

end
