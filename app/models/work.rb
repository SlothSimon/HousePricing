class Work < ActiveRecord::Base
    
    has_many :houses, through: :works_houses
    has_many :works_houses, class_name: "WorksHouses"
    
    def self.to_csv
    attributes = %w{id name distance latitude longitude}
    
    CSV.generate(headers: true) do |csv|
    csv << attributes
    Work.all.each do |work|
    csv << attributes.map { |attr| work.send(attr) }
end
end
end

end
