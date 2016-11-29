class Subway < ActiveRecord::Base
    
    has_many :houses, through: :subways_houses
    has_many :subways_houses, class_name: "SubwaysHouses"
    
    def self.to_csv
    attributes = %w{id name distance latitude longitude}
    
    CSV.generate(headers: true) do |csv|
    csv << attributes
    Subway.all.each do |subway|
    csv << attributes.map { |attr| subway.send(attr) }
end
end
end

end
