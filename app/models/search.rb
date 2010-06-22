class Search
  BEDROOMS = (0..8).to_a
  BATHROOMS = (1..10).to_a.map { |x| x/2.0 }

  attr_accessor :min_bedrooms, :max_bedrooms
  attr_accessor :min_bathrooms, :max_bathrooms
  attr_accessor :min_rent, :max_rent
  attr_accessor :min_square_footage, :max_square_footage
  attr_accessor :neighborhood_ids

  def initialize(options = {})
    @min_bedrooms = (options[:min_bedrooms] || 0).to_i
    @max_bedrooms = (options[:max_bedrooms] || 8).to_i
    @min_bathrooms = (options[:min_bathrooms] || 0.5).to_f
    @max_bathrooms = (options[:max_bathrooms] || 5).to_f
    @min_rent = (options[:min_rent] || 1500).to_i
    @max_rent = (options[:max_rent] || 3000).to_i
    @min_square_footage = (options[:min_square_footage] || 250).to_i
    @max_square_footage = (options[:max_square_footage] || 800).to_i
    @neighborhood_ids = (options[:neighborhood_ids] || []).collect {|n| n.to_i}
  end

  def results
    conditions = [].tap do |condition|
      condition << "bedrooms >= #{@min_bedrooms}"
      condition << "bedrooms <= #{@max_bedrooms}"
      condition << "bathrooms >= #{@min_bathrooms}"
      condition << "bathrooms <= #{@max_bathrooms}"
      condition << "rent >= #{@min_rent}"
      condition << "rent <= #{@max_rent}"
      condition << "square_footage >= #{@min_square_footage}"
      condition << "square_footage <= #{@max_square_footage}"
      condition << "addresses.neighborhood_id IN (#{@neighborhood_ids.join(",")})" unless @neighborhood_ids.empty?
      condition << "apartments.state = 'published'"
    end.join(" AND ")
    Apartment.all(:conditions => conditions, :joins => :address)
  end
end