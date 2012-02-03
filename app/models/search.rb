class Search
  BATHROOMS = (1..10).to_a.map { |x| x/2.0 }

  attr_accessor :min_bedrooms, :max_bedrooms
  attr_accessor :min_bathrooms, :max_bathrooms
  attr_accessor :min_rent, :max_rent
  attr_accessor :min_square_footage, :max_square_footage
  attr_accessor :neighborhood_ids, :neighborhood_id
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
                          [(eval(options[:neighborhood_ids]) rescue [])].flatten.compact
                        elsif options[:neighborhood_ids].is_a?(Array)
                          options[:neighborhood_ids]
                        else
                          []
                        end
    @neighborhood_id = options[:neighborhood_id]
    @page = options[:page]
  end

  def results
    Sunspot.search(Apartment) do
      if max_rent.present?
        any_of do
          with(:rent).less_than(max_rent)
          with(:rent).equal_to(max_rent)
        end
      end

      if min_bedrooms.present?
        any_of do
          with(:bedrooms).greater_than(min_bedrooms)
          with(:bedrooms).equal_to(min_bedrooms)
        end
      end

      with(:published, true)
      with(:neighborhood_ids, neighborhood_id) if neighborhood_id.present?
      order :published_at, :desc
    end.results
  end

  def paginated_results
    Sunspot.search(Apartment) do
      if max_rent.present?
        any_of do
          with(:rent).less_than(max_rent)
          with(:rent).equal_to(max_rent)
        end
      end

      if min_bedrooms.present?
        any_of do
          with(:bedrooms).greater_than(min_bedrooms)
          with(:bedrooms).equal_to(min_bedrooms)
        end
      end

      with(:published, true)
      with(:neighborhood_ids, neighborhood_id) if neighborhood_id.present?
      order :published_at, :desc
      paginate :page => page, :per_page => 10
    end.results
  end
end
