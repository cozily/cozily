class Yelp
  include HTTParty
  base_uri 'api.yelp.com'

  def neighborhood_for_lat_and_lng(lat, lng)
    options = { :query => { :lat => lat,
                            :long => lng,
                            :ywsid => '7a05VXb3EXz850ByvWF90w' } }
    self.class.get('/neighborhood_search', options)
  end

  def restaurants_for_lat_and_lng(lat, lng)
    options = { :query => { :lat => lat,
                            :long => lng,
                            :radius => 0.1,
                            :category => "restaurants",
                            :limit => 10,
                            :ywsid => '7a05VXb3EXz850ByvWF90w' } }
    self.class.get('/business_review_search', options)
  end
end
