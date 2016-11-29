require 'csv'
class WorksHouses < ActiveRecord::Base

  belongs_to :house
  belongs_to :work


  def self.to_csv
    attributes = %w{id work_id house_id}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      WorksHouses.all.each do |col|
        csv << attributes.map { |attr| col.send(attr) }
      end
    end
  end

end
