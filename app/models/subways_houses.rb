require 'csv'
class SubwaysHouses < ActiveRecord::Base

  belongs_to :house
  belongs_to :subway


  def self.to_csv
    attributes = %w{id subway_id house_id}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      SubwaysHouses.all.each do |col|
        csv << attributes.map { |attr| col.send(attr) }
      end
    end
  end

end
