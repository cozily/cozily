require 'nokogiri'
require 'open-uri'
require 'net/http'
include ActionView::Helpers::NumberHelper
require 'csv'

BASE_URL = "http://a810-bisweb.nyc.gov/bisweb/PropertyBrowseByBBLServlet?allborough=%d&allblock=%d"
BOROUGHS = [["Manhattan", 1],
            ["Bronx", 2],
            ["Brooklyn", 3],
            ["Queens", 4],
            ["Staten Island", 5]]

namespace :import do
  namespace :nyc do
    task :all => :environment do
      `cd #{Rails.root.join("lib","data")} && tar -xzf nyc_bob.tar.gz`

      CSV.foreach(Rails.root.join("lib", "data", "bobaadr.txt"), :headers => :first_row) do |row|
        row = row.to_hash unless row.is_a? Hash
        row.values.map(&:strip!)

        NycBuilding.create(:boro => row["boro"],
                           :block => row["block"],
                           :lot => row["lot"],
                           :bin => row["bin"],
                           :lhnd => row["lhnd"],
                           :lhns => row["lhns"],
                           :lcontpar => row["lcontpar"],
                           :lsos => row["lsos"],
                           :hhnd => row["hhnd"],
                           :hhns => row["hhns"],
                           :hcontpar => row["hcontpar"],
                           :hsos => row["hsos"],
                           :scboro => row["scboro"],
                           :sc5 => row["sc5"],
                           :sclgc => row["sclgc"],
                           :stname => row["stname"],
                           :addrtype => row["addrtype"],
                           :realb7sc => row["realb7sc"],
                           :validlgcs => row["validlgcs"],
                           :parity => row["parity"],
                           :b10sc => row["b10sc"],
                           :segid => row["segid"])
        putc "."
      end

      # CSV.foreach(Rails.root.join("lib", "data", "bobabbl.txt"), :headers => :first_row) do |row|
        # row.each_value.map(&:strip!)
        # NycTaxLot.create(:boro => row["boro"],
                         # :loboro, :limit => 1
                         # :loblock, :limit => 5
                         # :lolot, :limit => 4
                         # :lobblssc, :limit => 1
                         # :hiboro, :limit => 1
                         # :hiblock, :limit => 5
                         # :hilot, :limit => 4
                         # :hibblssc, :limit => 1
                         # :boro, :limit => 1
                         # :block, :limit => 5
                         # :lot, :limit => 4
                         # :bblssc, :limit => 1
                         # :billboro, :limit => 1
                         # :billblock, :limit => 5
                         # :billlot, :limit => 4
                         # :billbblssc, :limit => 1
                         # :condoflag, :limit => 1
                         # :condonum, :limit => 4
                         # :coopnum, :limit => 4
                         # :numbf, :limit => 2
                         # :numaddr, :limit => 4
                         # :vacant, :limit => 1
                         # :interior, :limit => 1
        # putc "."
      # end

      `cd #{Rails.root.join("lib/data")} && rm bob*.txt`
    end
  end

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
