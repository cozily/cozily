require 'nokogiri'
require 'open-uri'
require 'net/http'
include ActionView::Helpers::NumberHelper

BASE_URL = "http://a810-bisweb.nyc.gov/bisweb/PropertyBrowseByBBLServlet?allborough=%d&allblock=%d"
BOROUGHS = [["Manhattan", 1],
            ["Bronx", 2],
            ["Brooklyn", 3],
            ["Queens", 4],
            ["Staten Island", 5]]

namespace :import do
  namespace :buildings do
    task :list => :environment do
      puts "Starting..."

      total_bytes = 0
      BOROUGHS.each do |borough_name, borough_id|
        File.open("lib/data/#{borough_name.parameterize}.txt", "w+") do |f|
          (1..10_000).each do |block_num|
            url = BASE_URL % [borough_id, block_num]
            puts "\nFetching '#{url}'..."

            content = retryable(:tries => 5, :sleep => 10) do
              page = open(url)
              total_bytes += page.size
              puts "Retrieved. (#{number_to_human_size(page.size)} of #{number_to_human_size(total_bytes)} total)"
              Nokogiri::HTML(page)
            end

            errors = content.css("td.errormsg").first.try(:inner_text)
            if errors == "NO PROPERTY RECORDS FOUND FOR INQUIRY CRITERIA!"
              puts "No entries found for #{borough_name} block #{block_num}."
              next
            end

            rows = content.css("table")[3].css("tr")[1..-1]

            rows.each do |row|
              data = row.css("td")
              f.puts [data.map(&:inner_text).map(&:strip).join(","), borough_id, block_num].join(",")
            end
            puts "Found #{rows.count} entries."
          end
        end
      end
    end
  end
end
