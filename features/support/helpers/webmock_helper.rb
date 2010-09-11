WebMock.disable_net_connect!(:allow_localhost => true)

google_url = "http://maps.google.com/maps/geo"
google_query = {
  :key => "ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg",
  :oe => "utf-8",
  :output => "xml",
}

[ { :q => "99 S 3rd St 11211" },
  { :q => "111 W 74th St 10023" },
  { :q => "151 Huron St 11222" },
  { :q => "546 Henry St 11231" },
  { :q => "268 Bowery 10012" },
  { :q => "New York City" },
  { :q => "546 Henry St 11231", :spn => "0.270637800000003,0.512237600000006", :ll => "40.7144983232441,-74.0064936541319" } ].each do |location|
  query = google_query.merge(location)
  WebMock.stub_http_request(:get, google_url).with(:query => query).to_return(`curl -is "#{google_url}?#{query.to_query}"`)
end
query = "http://maps.google.com/maps/geo?key=ABQIAAAA9wWHEGNCfZW2F9-qCEHgohSNtFT0HrWdEyzoj3osWY55tZjYABRmZkmve1rwY6-nWvpT-N3MZcV_rg&ll=40.7144983232441,-74.0064936541319&oe=utf-8&output=xml&q=546%20Henry%20St%2011231&spn=0.270637800000003,0.512237600000006"
WebMock.stub_http_request(:get, query).to_return(`curl -is "#{query}"`)

yelp_url = "http://api.yelp.com/neighborhood_search"
yelp_query = { :ywsid => "7a05VXb3EXz850ByvWF90w" }

[ { :lat => "40.733134", :long => "-73.955389" },
  { :lat => "40.6824793", :long => "-74.0003197" },
  { :lat => "40.713106", :long => "-73.963561" },
  { :lat => "40.779237", :long => "-73.978437" },
  { :lat => "40.723535", :long => "-73.993236" },
  { :lat => "40.68244", :long => "-74.0003021" } ].each do |location|
  query = yelp_query.merge(location)
  WebMock.stub_http_request(:get, yelp_url).with(:query => query).to_return(`curl -is "#{yelp_url}?#{query.to_query}"`)
end

yelp_url = "http://api.yelp.com/business_review_search"
yelp_query = { :ywsid => "7a05VXb3EXz850ByvWF90w",
               :category => "restaurants",
               :radius => "0.1",
               :limit => "10" }

[ { :lat => "40.733134", :long => "-73.955389" },
  { :lat => "40.779237", :long => "-73.978437" },
  { :lat => "40.713106", :long => "-73.963561" },
  { :lat => "40.723535", :long => "-73.993236" } ].each do |location|
  query = yelp_query.merge(location)
  WebMock.stub_http_request(:get, yelp_url).with(:query => query).to_return(`curl -is "#{yelp_url}?#{query.to_query}"`)
end
