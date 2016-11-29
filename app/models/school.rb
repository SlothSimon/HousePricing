class School < ActiveRecord::Base
    
    has_many :houses, through: :schools_houses
    has_many :schools_houses, class_name: "SchoolsHouses"
    
    def self.to_csv
        attributes = %w{id name distance latitude longitude}
        
        CSV.generate(headers: true) do |csv|
            csv << attributes
            School.all.each do |school|
                csv << attributes.map { |attr| school.send(attr) }
            end
        end
    end

end
