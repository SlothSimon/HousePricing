require 'csv'
class HospitalsHouses < ActiveRecord::Base

  belongs_to :house
  belongs_to :hospital


  def self.to_csv
    attributes = %w{id hospital_id house_id}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      HospitalsHouses.all.each do |col|
        csv << attributes.map { |attr| col.send(attr) }
      end
    end
  end

end
