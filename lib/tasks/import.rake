require 'nokogiri'
require 'open-uri'
require 'net/http'

def assign_bedrooms(apartment, features)
  case features
  when /studio|studio conv/i
    apartment.bedrooms = 0
  when /1 bed|one bed|1 conv|one conv/i
    apartment.bedrooms = 1
  when /2 bed|two bed|2 conv|two conv|2 wing|two wing|/i
    apartment.bedrooms = 2
  when /3 bed|three bed|3 conv|three conv/i
    apartment.bedrooms = 3
  when /4 bed|four bed|4 conv|four conv/i
    apartment.bedrooms = 4
  else
    apartment.bedrooms = 0
  end
end

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

def assign_urban_edge_apartment_features(apartment, features)
  if features.include?("Dishwasher")
    apartment.features << Feature.find_by_name_and_category("dishwasher", :apartment)
  end
  if features.include?("High Ceilings")
    apartment.features << Feature.find_by_name_and_category("high ceilings", :apartment)
  end
  if features.include?("A/C Available") || features.include?("Air Conditioning Included") || features.include?("Central Air Conditioning")
    apartment.features << Feature.find_by_name_and_category("air conditioning", :apartment)
  end
  if features.include?("Balcony")
    apartment.features << Feature.find_by_name_and_category("balcony", :apartment)
  end
  if features.include?("Exposed Brick")
    apartment.features << Feature.find_by_name_and_category("exposed brick", :apartment)
  end
  if features.include?("Washer/Dryer in Unit") || features.include?("Stackable Washer/Dryer in Home")
    apartment.features << Feature.find_by_name_and_category("washer/dryer in unit", :apartment)
  end
end

def assign_urban_edge_building_features(apartment, features)
  if features.include?("Elevator")
    apartment.features << Feature.find_by_name_and_category("elevator", :building)
  end
  if features.include?("Laundry in Building")
    apartment.features << Feature.find_by_name_and_category("washer/dryer", :building)
  end
  if features.include?("Indoor Pool") || features.include?("Outdoor Pool")
    apartment.features << Feature.find_by_name_and_category("pool", :building)
  end
  if features.include?("High-rise (26+ Floors)")
    apartment.features << Feature.find_by_name_and_category("high-rise", :building)
  end
  if features.include?("Full-time Doorman") || features.include?("Part-time Doorman") || features.include?("White Glove Doorman")
    apartment.features << Feature.find_by_name_and_category("doorman", :building)
  end
  if features.include?("Rooftop Deck")
    apartment.features << Feature.find_by_name_and_category("roof deck", :building)
  end
  if features.include?("Live-in Super")
    apartment.features << Feature.find_by_name_and_category("live-in super", :building)
  end
end

def assign_urban_edge_pet_features(apartment, features)
  if features =~ /Cats OK/
    apartment.features << Feature.find_by_name_and_category("cats allowed", :pet)
  end
  if features =~ /Dogs OK/
    apartment.features << Feature.find_by_name_and_category("dogs allowed", :pet)
  end
  if features =~ /Pets allowed on an individual basis/
    apartment.features << Feature.find_by_name_and_category("case-by-case", :pet)
  end
end

namespace :import do
  namespace :urban_edge do
    task :all => :environment do
      log = Logger.new(Rails.root.join("log","import","urban_edge","debug.log"))
      log.level = Logger::DEBUG
      log.formatter = proc do |severity, datetime, progname, msg|
        "[#{severity}] #{datetime.to_s(:logger)}: #{msg}\n"
      end

      XML_FEED = "http://www.urbanedgeny.com/feeds/22858389ce.xml?1326301614"
      # XML_FEED = "http://www.urbanedgeny.com/feeds/39a6a3a2bd.xml?1321654581"

      log.debug "Starting import."
      log.debug %Q{Retrieving "#{XML_FEED}"}
      doc = retryable(:tries => 5, :sleep => 10) do
        Nokogiri::XML(open(XML_FEED))
      end

      @properties = []
      doc.xpath("/PhysicalProperty/Property").each do |property|
        @properties << property
      end
      log.debug "#{@properties.size} properties found.."

      @properties.each do |property|
        property_url = property.xpath("Identification/WebSite").inner_text
        log.debug %Q{Retrieving "#{property_url}"...}
        page = retryable(:tries => 5, :sleep => 10) do
          Nokogiri::HTML(open(property_url))
        end

        name = property.xpath("Identification/MarketingName").inner_text
        phone = property.xpath("Identification/Phone/Number").inner_text

        email = property.xpath("Identification/Email").inner_text
        email = "#{name.gsub(" ", "").downcase}@cozi.ly" if email.blank?

        unless @user = User.find_by_email(email)
          @user = User.create(:first_name => name,
                              :last_name => "Office",
                              :email => email,
                              :password => "password!",
                              :password_confirmation => "password!",
                              :receive_match_summaries => false,
                              :receive_listing_summaries => false,
                              :receive_match_notifications => false,
                              :phone => phone,
                              :roles => Role.find_all_by_name("lister"))
        end

        page.css("table.views-table tbody tr").each do |row|
          full_address = property.xpath("Identification/Address/*").map(&:inner_text).join(", ")

          unit = row.css("td.views-field-phpcode").inner_text.strip.gsub("-", "")
          unit = nil if unit.length > 5

          url = "http://www.urbanedgeny.com" + row.css("td.views-field-phpcode a").attribute("href").inner_text
          external_id = url.split("/").last

          bedrooms = row.css("td.views-field-field-bedroom-value").inner_text.match(/\d+/).to_s.to_i || 0

          bathrooms = row.css("td.views-field-field-bathroom-value").inner_text.match(/\d*\.?\d+/).to_s.to_f || 0

          rent = row.css("td.views-field-field-price-value").inner_text.gsub(",", "").match(/\d+/).to_s.to_i

          start_date = row.css("td.views-field-field-date-value").inner_text.strip.gsub("Immediately", Date.today.to_s)

          log.debug %Q{Retrieving "#{url}"}
          listing = retryable(:tries => 5, :sleep => 10) do
            Nokogiri::HTML(open(url))
          end

          building_features = listing.css("div.property-amen ul li").map(&:inner_text)

          apartment_features = listing.css("div.listing-amen ul li").map(&:inner_text)

          pet_features = listing.css("div.property-amen div:contains('Pet policy')").inner_text.strip

          @apartment = Apartment.find_by_external_id(external_id)
          if @apartment.nil?
            @apartment = Apartment.new(:full_address => full_address,
                                       :unit => unit,
                                       :rent => rent,
                                       :bathrooms => bathrooms,
                                       :bedrooms => bedrooms,
                                       :start_date => start_date,
                                       :external_id => external_id,
                                       :external_url => url,
                                       :external_source => :urban_edge,
                                       :imported => true,
                                       :user => @user)

            assign_urban_edge_apartment_features(@apartment, apartment_features)
            assign_urban_edge_building_features(@apartment, building_features)
            assign_urban_edge_pet_features(@apartment, pet_features)

            @apartment.save

            images = listing.css("div#slide-runner div.slide a img")
            images.each do |img|
              retryable(:tries => 5) do
                image_url = img["src"].gsub(" ", "%20")
                file_name = image_url.split("/").last
                large_image_url = "/feeds/images/#{file_name}"
                file_path = Tempfile.new(["image",".jpg"]).path
                log.debug %Q{Fetching "http://www.urbanedgeny.com#{large_image_url}"...}
                Net::HTTP.start("www.urbanedgeny.com") do |http|
                  http.read_timeout = 120
                  response = http.get(large_image_url)
                  open(file_path, "wb") do |file|
                    file.write(response.body)
                  end
                end
                log.debug %Q{=> "#{file_path}"}

                if File.exist?(file_path)
                  upload = ActionDispatch::Http::UploadedFile.new({
                    :filename => file_name,
                    :content_type => "image/jpeg",
                    :tempfile => File.open(file_path)
                  })

                  photo = @apartment.photos.create(:image => upload)
                  log.debug "The photo is #{photo.valid? ? "valid" : "INVALID"}."
                end
              end
            end

            log.debug "Publishing listing..."
            @apartment.publish
            if @apartment.published?
              log.debug "Successfully published."
            else
              log.error "Failed to publish."
            end
          else
            log.debug "Apartment already exists..."
            if @apartment.user.nil?
              log.debug "User is nil, reattaching."
              unless @user = User.find_by_email(email)
                @user = User.create(:first_name => name,
                                    :last_name => "Office",
                                    :email => email,
                                    :password => "password!",
                                    :password_confirmation => "password!",
                                    :receive_match_summaries => false,
                                    :receive_listing_summaries => false,
                                    :receive_match_notifications => false,
                                    :phone => phone,
                                    :roles => Role.find_all_by_name("lister"))
              end
              @apartment.user = @user
              @apartment.save
            end

            if @apartment.address.nil?
              console_for(binding)
            end

            log.debug "Publishing listing..."
            @apartment.publish
            if @apartment.published?
              log.debug "Successfully published."
            else
              log.error "Failed to publish."
            end
          end
        end
      end
      log.debug "Done."
    end
  end

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
            apartment["start_date"] = tr.css("td")[0].content.gsub("IMED","12/05/2011")
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
        address = Address.for_full_address(apartment["full_address"])
        next if address.nil?

        @apartment = Apartment.find_by_address_id_and_unit(address.id, apartment["unit"])

        unless @apartment.nil?
          puts "Apartment already exists - updating! (#{@apartment.id})"
          @apartment.rent = apartment["rent"]
          @apartment.published_at = Time.now
          assign_bedrooms(@apartment, apartment["features"])
          @apartment.bathrooms = 1

          @apartment.save
          @apartment.publish! unless @apartment.published?
        else
          @apartment = Apartment.new(:full_address => apartment["full_address"],
                                    :unit => apartment["unit"],
                                    :rent => apartment["rent"],
                                    :bathrooms => 1,
                                    :square_footage => (/(\d+)(.*)sq/i.match(apartment["features"])[1].to_i rescue nil),
                                    :start_date => Date.strptime(apartment["start_date"], "%m/%d/%Y"),
                                    :user => @user)

          assign_bedrooms(@apartment, apartment["features"])
          assign_pet_features(@apartment)
          assign_building_features(@apartment, apartment["building_features"].downcase)
          assign_apartment_features(@apartment, apartment["features"].downcase)
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
