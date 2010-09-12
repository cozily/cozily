WebMock.disable_net_connect!(:allow_localhost => true)

WEBMOCK_SITES = YAML.load_file("#{Rails.root}/features/support/webmock/config.yaml")

WEBMOCK_SITES.each do |site|
  site["queries"].each do |query|
    base_url = site["url"]
    querystring = site["params"].merge(query)
    url = "#{base_url}?#{querystring.to_query}"
    WebMock.stub_http_request(:get, base_url).with(:query => querystring).to_return(`curl -is "#{url}"`)
  end
end
