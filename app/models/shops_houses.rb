require 'csv'
class ShopsHouses < ActiveRecord::Base

  belongs_to :house
  belongs_to :shop


  def self.to_csv
    attributes = %w{id shop_id house_id}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      ShopsHouses.all.each do |col|
        csv << attributes.map { |attr| col.send(attr) }
      end
    end
  end

end
