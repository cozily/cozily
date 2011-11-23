namespace :stations do
  desc "Populate station data with CSV from the MTA"
  task :populate => :environment do
    puts "Dropping existing station data.."
    Station.delete_all
    StationTrain.delete_all
    Train.delete_all

    puts "Loading new station data.."
    CSV.foreach("lib/mta_subway_info.csv", :headers => :first_row) do |row|
      station = Station.create(:name => row["Station Name"],
                               :line => row["Line"],
                               :lat => row["Latitude"],
                               :lng => row["Longitude"])
      station = Station.find_by_lat_and_lng(row["Latitude"], row["Longitude"]) unless station

      (1..9).each do |num|
        name = row["Route#{num}"]
        if name.present?
          train = Train.find_or_create_by_name(name)
          StationTrain.create(:station => station, :train => train)
        end
      end
    end
  end
end
