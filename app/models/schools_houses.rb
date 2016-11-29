require 'csv'
class SchoolsHouses < ActiveRecord::Base

  belongs_to :house
  belongs_to :school


  def self.to_csv
    attributes = %w{id school_id house_id}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      SchoolsHouses.all.each do |col|
        csv << attributes.map { |attr| col.send(attr) }
      end
    end
  end

end
