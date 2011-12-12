class Search
  BATHROOMS = (1..10).to_a.map { |x| x/2.0 }

  attr_accessor :min_bedrooms, :max_bedrooms
  attr_accessor :min_bathrooms, :max_bathrooms
  attr_accessor :min_rent, :max_rent
  attr_accessor :min_square_footage, :max_square_footage
  attr_accessor :neighborhood_ids
  attr_accessor :page

  def initialize(options = {})
    @min_bedrooms = (options[:min_bedrooms])
    @max_bedrooms = (options[:max_bedrooms] || 8).to_i
    @min_bathrooms = (options[:min_bathrooms] || 0.5).to_f
    @max_bathrooms = (options[:max_bathrooms] || 5).to_f
    @min_rent = (options[:min_rent] || 1500).to_i
    @max_rent = (options[:max_rent])
    @min_square_footage = (options[:min_square_footage] || 250).to_i
    @max_square_footage = (options[:max_square_footage] || 800).to_i
    @neighborhood_ids = if options[:neighborhood_ids].is_a?(String)
                          [(eval(options[:neighborhood_ids]) rescue [])].flatten
                        elsif options[:neighborhood_ids].is_a?(Array)
                          options[:neighborhood_ids]
                        else
                          []
                        end
    @page = options[:page]
  end

  def results
    apartments = Apartment.where(:state => "published")
    apartments = apartments.where("bedrooms >= #{@min_bedrooms}") if @min_bedrooms.present?
    apartments = apartments.where("rent <= #{@max_rent}") if @max_rent.present?
    apartments = apartments.joins(:address).order("published_at desc")
    unless @neighborhood_ids.empty?
      apts = apartments.select { |a| (a.neighborhoods.map(&:id) & @neighborhood_ids).present? }
      apartments = Apartment.where(:id => apts.map(&:id))
    end
    apartments
  end

  def paginated_results
    results.paginate(:page => page, :per_page => Apartment.per_page)
  end
end
