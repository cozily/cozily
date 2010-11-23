namespace :webmock do
  desc "Cache webmock fixtures"
  task :cache_fixtures => :environment do
    WEBMOCK_SITES = YAML.load_file("#{Rails.root}/spec/support/webmock/sites.yml")
    WEBMOCK_SITES.each do |site|
      site["queries"].each do |query|
        base_url = site["url"]
        querystring = (site["params"] || {}).merge(query)
        url = "#{base_url}?#{querystring.to_query}"
        response = `curl -is "#{url}"`
        hash = Digest::MD5.hexdigest(url)
        File.open("#{Rails.root}/spec/support/webmock/cache/#{hash}", "w") do |f|
          f.puts response
          f.close
        end
      end
    end
  end
end