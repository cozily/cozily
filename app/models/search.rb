class Search
  BEDROOMS = (0..8).to_a
  BATHROOMS = (1..10).to_a.map { |x| x/2.0 }

  attr_accessor :min_bedrooms, :max_bedrooms
  attr_accessor :min_bathrooms, :max_bathrooms
  attr_accessor :min_rent, :max_rent
  attr_accessor :min_square_footage, :max_square_footage
  attr_accessor :neighborhood_ids

  def initialize(options = {})
    @min_bedrooms = (options[:min_bedrooms] || 0)
    @max_bedrooms = (options[:max_bedrooms] || 8).to_i
    @min_bathrooms = (options[:min_bathrooms] || 0.5).to_f
    @max_bathrooms = (options[:max_bathrooms] || 5).to_f
    @min_rent = (options[:min_rent] || 1500).to_i
    @max_rent = (options[:max_rent] || 3000)
    @min_square_footage = (options[:min_square_footage] || 250).to_i
    @max_square_footage = (options[:max_square_footage] || 800).to_i
    @neighborhood_ids = (options[:neighborhood_ids] || []).collect {|n| n.to_i}
  end

  def results
    conditions = [].tap do |condition|
      condition << "bedrooms >= #{@min_bedrooms}" if @min_bedrooms.present?
      condition << "bedrooms <= #{@max_bedrooms}"
      condition << "bathrooms >= #{@min_bathrooms}"
      condition << "bathrooms <= #{@max_bathrooms}"
      condition << "rent >= #{@min_rent}"
      condition << "rent <= #{@max_rent}" if @max_rent.present?
      condition << "square_footage >= #{@min_square_footage}"
      condition << "square_footage <= #{@max_square_footage}"
      condition << "apartments.state = 'listed'"
    end.join(" AND ")
    apartments = Apartment.all(:conditions => conditions, :joins => :address)
    unless @neighborhood_ids.empty?
      apartments = apartments.select { |a| (a.neighborhoods.map(&:id) & @neighborhood_ids).present? }
    end
    apartments
  end
end
