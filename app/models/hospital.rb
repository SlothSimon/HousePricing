class Hospital < ActiveRecord::Base
    
    has_many :houses, through: :hospitals_houses
    has_many :hospitals_houses, class_name: "HospitalsHouses"
    
    def self.to_csv
    attributes = %w{id name distance latitude longitude}
    
    CSV.generate(headers: true) do |csv|
    csv << attributes
    Hospital.all.each do |hospital|
    csv << attributes.map { |attr| hospital.send(attr) }
end
end
end

end
