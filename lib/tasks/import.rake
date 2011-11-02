require 'nokogiri'
require 'open-uri'

def assign_pet_features(apartment)
  apartment.features << Feature.find_by_name_and_category("case-by-case", :pet)
end

def assign_building_features(apartment, features)
  if features =~ /doorman/i
    apartment.features << Feature.find_by_name_and_category("doorman", :building)
  end
  if features =~ /super/i
    apartment.features << Feature.find_by_name_and_category("live-in super", :building)
  end
  if features =~ /roof deck/i
    apartment.features << Feature.find_by_name_and_category("roof deck", :building)
  end
  if features =~ /live(.*)super/i
    apartment.features << Feature.find_by_name_and_category("live-in super", :building)
  end
  if features =~ /elevator/i
    apartment.features << Feature.find_by_name_and_category("elevator", :building)
  end
  if features =~ /dryer|laundry/i
    apartment.features << Feature.find_by_name_and_category("washer/dryer", :building)
  end
end

def assign_apartment_features(apartment, features)
  if features =~ /dishwasher/i
    apartment.features << Feature.find_by_name_and_category("dishwasher", :apartment)
  end
  if features =~ /furnish/i
    apartment.features << Feature.find_by_name_and_category("furnished", :apartment)
  end
  if features =~ /brick/i
    apartment.features << Feature.find_by_name_and_category("exposed brick", :apartment)
  end
  if features =~ /air cond/i
    apartment.features << Feature.find_by_name_and_category("air conditioning", :apartment)
  end
  if features =~ /balcony/i
    apartment.features << Feature.find_by_name_and_category("balcony", :apartment)
  end
  if features =~ /high ceiling|14(.*)ceiling/i
    apartment.features << Feature.find_by_name_and_category("high ceilings", :apartment)
  end
  if features =~ /sleep(.*)loft/i
    apartment.features << Feature.find_by_name_and_category("sleeping loft", :apartment)
  end
end

namespace :import do
  namespace :jakobson do
    task :all => :environment do
      @user = User.find_by_email("ybriones@jakobson.com")
      raise "User not found!" if @user.nil?

      doc = Nokogiri::HTML(open("http://nofeerentals.com/apartments.asp"))
      apartments = []
      doc.css(%Q{form table tr}).each do |tr|
        case tr.attributes["bgcolor"].try("value")
          when "#cdc9a5"
            @street = tr.css("strong").first.content
            @building_features = tr.css("font").last.content
          when "#ffffff", "#eeeeee"
            apartment = {}
            apartment["full_address"] = "#{@street}, New York, NY"
            apartment["start_date"] = tr.css("td")[0].content.gsub("IMED","2011-11-01")
            apartment["unit"] = tr.css("td")[1].content.strip
            apartment["features"] = tr.css("td")[2].content
            apartment["building_features"] = @building_features
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
                                  :bathrooms => 1,
                                  :square_footage => (/(\d+)(.*)sq/i.match(apartment["features"])[1].to_i rescue nil),
                                  :start_date => Date.parse(apartment["start_date"]),
                                  :user => @user)

        case apartment["features"]
        when /studio|studio conv/i
          @apartment.bedrooms = 0
        when /1 bed|one bed|1 conv|one conv/i
          @apartment.bedrooms = 1
        when /2 bed|two bed|2 conv|two conv/i
          @apartment.bedrooms = 2
        when /3 bed|three bed|3 conv|three conv/i
          @apartment.bedrooms = 3
        when /4 bed|four bed|4 conv|four conv/i
          @apartment.bedrooms = 4
        end

        assign_pet_features(@apartment)
        assign_building_features(@apartment, apartment["building_features"].downcase)
        assign_apartment_features(@apartment, apartment["features"].downcase)

        puts @apartment.inspect

        @apartment.save
        puts %Q{Fetching #{apartment["url"]}..}
        doc = Nokogiri::HTML(open(apartment["url"]))

        images = doc.css(%Q{td[align=left] > img})
        puts "#{images.count} images found."
        images.each do |img|
          image_url = %Q{http://nofeerentals.com#{img["src"].gsub(" ", "%20")}}
          puts image_url
          image = open(URI.parse(image_url))
          Image.create(:apartment => @apartment, :asset => image)
        end

        puts @apartment.valid?
        puts @apartment.errors.full_messages

        begin
          @apartment.publish!
        rescue
          puts "Couldn't publish apartment ##{@apartment.id}!!"
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
