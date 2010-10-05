require 'nokogiri'
require 'open-uri'

namespace :import do
  namespace :jakobson do
    task :all => :environment do
      @user = User.find_by_email("todd+jakobson@cozi.ly")
      raise "User not found!" if @user.nil?

      doc = Nokogiri::HTML(open("http://nofeerentals.com/apartments.asp"))
      apartments = []
      doc.css(%Q{form table tr}).each do |tr|
        case tr.attributes["bgcolor"].try("value")
          when "#cdc9a5"
            @street = tr.css("strong").first.content
          when "#ffffff", "#eeeeee"
            apartment = {}
            apartment["full_address"] = @street
            apartment["start_date"] = tr.css("td")[0].content.gsub("IMED","2010-10-01")
            apartment["unit"] = tr.css("td")[1].content.strip
            apartment["rent"] = tr.css("td")[3].content.gsub("$", "")
            apartment["url"] = tr.css("td a").first["href"]
            apartments << apartment
        end
      end
      puts %Q{#{apartments.count} apartments found.}

      apartments.each do |apartment|
        @apartment = Apartment.new(:full_address => apartment["full_address"],
                                  :unit => apartment["unit"],
                                  :rent => apartment["rent"],
                                  :start_date => Date.parse(apartment["start_date"]),
                                  :user => @user)
        puts %Q{Fetching #{apartment["url"]}..}
        doc = Nokogiri::HTML(open(apartment["url"]))
        images = doc.css(%Q{td[align=left] > img})
        puts "#{images.count} images found."
        @apartment.save
        images.each do |img|
          image_url = %Q{http://nofeerentals.com#{img["src"].gsub(" ", "%20")}}
          image = open(URI.parse(image_url))
          Image.create(:apartment => @apartment, :asset => image)
        end
      end
    end

    task :user => :environment do
      @user = User.create(:first_name => "Jakobson",
            :last_name => "Properties",
            :email => "todd+jakobson@cozi.ly",
            :password => "pass",
            :password_confirmation => "pass",
            :phone => "2125331300",
            :roles => Role.find_all_by_name("lister"))
    end
  end
end