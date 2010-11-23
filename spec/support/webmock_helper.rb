WebMock.disable_net_connect!(:allow_localhost => true)

puts "*" * 80
puts "*  READING CACHED RESPONSES FOR WEBMOCK"

WEBMOCK_SITES = YAML.load_file("#{Rails.root}/spec/support/webmock/sites.yml")
WEBMOCK_SITES.each do |site|
  site["queries"].each do |query|
    base_url = site["url"]
    querystring = (site["params"] || {}).merge(query)
    url = "#{base_url}?#{querystring.to_query}"
    hash = Digest::MD5.hexdigest(url)
    file_name = "#{Rails.root}/spec/support/webmock/cache/#{hash}"
    if File.exists?(file_name)
      response = File.read(file_name)
      WebMock.stub_http_request(:get, base_url).with(:query => querystring).to_return(response)
    else
      puts "*  REQUESTING AND CACHING RESPONSE FOR '#{url}'"
      response = `curl -is "#{url}"`
      hash = Digest::MD5.hexdigest(url)
      cache_dir = "#{Rails.root}/spec/support/webmock/cache"
      Dir.mkdir(cache_dir) unless File.exist?(cache_dir)
      File.open("#{cache_dir}/#{hash}", "w") do |f|
        f.puts response
        f.close
      end
      WebMock.stub_http_request(:get, base_url).with(:query => querystring).to_return(response)
    end
  end
end

puts "*" * 80
