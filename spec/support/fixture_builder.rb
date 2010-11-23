FixtureBuilder.configure do |config|
  config.record_name_fields = %w{ first_name name }
  config.select_sql = %Q{ SELECT * FROM %s }
  config.delete_sql = %Q{ DELETE FROM %s }

  config.factory do
    finder_role = Factory(:role, :name => "finder")
    lister_role = Factory(:role, :name => "lister")
    admin_role = Factory(:role, :name => "admin")

    ["Baychester",
     "Bedford Park",
     "Belmont",
     "Castle Hill",
     "City Island",
     "Claremont Village",
     "Clason Point",
     "Co-op City",
     "Concourse",
     "Concourse Village",
     "Country Club",
     "East Tremont",
     "Eastchester",
     "Edenwald",
     "Edgewater Park",
     "Fieldston",
     "Fordham",
     "High Bridge",
     "Hunts Point",
     "Kingsbridge",
     "Longwood",
     "Melrose",
     "Morris Heights",
     "Morris Park",
     "Morrisania",
     "Mott Haven",
     "Mount Eden",
     "Mount Hope",
     "North Riverdale",
     "Norwood",
     "Olinville",
     "Parkchester",
     "Pelham Bay",
     "Pelham Gardens",
     "Port Morris",
     "Riverdale",
     "Schuylerville",
     "Soundview",
     "Spuyten Duyvil",
     "Throgs Neck",
     "Unionport",
     "University Heights",
     "Van Nest",
     "Wakefield",
     "West Farms",
     "Westchester Square",
     "Williamsbridge",
     "Woodlawn"].each do |name|
      Neighborhood.create(:name => name,
                          :city => "New York",
                          :state => "NY",
                          :country => "USA",
                          :borough => "Bronx")
    end

    ["Bath Beach",
     "Bay Ridge",
     "Bedford Stuyvesant",
     "Bensonhurst",
     "Boerum Hill",
     "Borough Park",
     "Brighton Beach",
     "Brooklyn Heights",
     "Brownsville",
     "Bushwick",
     "Canarsie",
     "Carroll Gardens",
     "City Line",
     "Clinton Hill",
     "Cobble Hill",
     "Columbia Street Waterfront District",
     "Coney Island",
     "Crown Heights",
     "Cypress Hills",
     "DUMBO",
     "Ditmas Park",
     "Downtown Brooklyn",
     "Dyker Heights",
     "East Flatbush",
     "East New York",
     "East Williamsburg",
     "Flatbush",
     "Flatlands",
     "Fort Greene",
     "Fort Hamilton",
     "Georgetown",
     "Gerritson Beach",
     "Gowanus",
     "Gravesend",
     "Greenpoint",
     "Highland Park",
     "Kensington",
     "Manhattan Beach",
     "Marine Park",
     "Midwood",
     "Mill Basin",
     "Mill Island",
     "New Lots",
     "Ocean Hill",
     "Ocean Parkway",
     "Paedergat Basin",
     "Park Slope",
     "Prospect Heights",
     "Prospect Lefferts Gardens",
     "Prospect Park South",
     "Red Hook",
     "Remsen Village",
     "Sea Gate",
     "Sheepshead Bay",
     "South Williamsburg",
     "Spring Creek",
     "Starret City",
     "Sunset Park",
     "Vinegar Hill",
     "Weeksville",
     "Williamsburg - North Side",
     "Williamsburg - South Side",
     "Windsor Terrace",
     "Wingate"].each do |name|
      Neighborhood.create(:name => name,
                          :city => "New York",
                          :state => "NY",
                          :country => "USA",
                          :borough => "Brooklyn")
    end

    ["Alphabet City",
     "Battery Park",
     "Chelsea",
     "Chinatown",
     "Civic Center",
     "East Harlem",
     "East Village",
     "Financial District",
     "Flatiron",
     "Gramercy",
     "Greenwich Village",
     "Harlem",
     "Hell's Kitchen",
     "Inwood",
     "Kips Bay",
     "Koreatown",
     "Little Italy",
     "Lower East Side",
     "Manhattan Valley",
     "Marble Hill",
     "Meatpacking District",
     "Midtown East",
     "Midtown West",
     "Morningside Heights",
     "Murray Hill",
     "NoHo",
     "Nolita",
     "Roosevelt Island",
     "SoHo",
     "South Street Seaport",
     "South Village",
     "Stuyvesant Town",
     "Theater District",
     "TriBeCa",
     "Two Bridges",
     "Union Square",
     "Upper East Side",
     "Upper West Side",
     "Washington Heights",
     "West Village",
     "Yorkville"].each do |name|
      Neighborhood.create(:name => name,
                          :city => "New York",
                          :state => "NY",
                          :country => "USA",
                          :borough => "Manhattan")
    end

    ["Arverne",
     "Astoria",
     "Astoria Heights",
     "Auburndale",
     "Bay Terrace",
     "Bayside",
     "Beechurst",
     "Bellaire",
     "Belle Harbor",
     "Bellerose",
     "Breezy Point",
     "Briarwood",
     "Cambria Heights",
     "College Point",
     "Douglaston",
     "Downtown Flushing",
     "East Elmhurst",
     "Edgemere",
     "Elmhurst",
     "Far Rockaway",
     "Floral Park",
     "Flushing",
     "Flushing Meadows",
     "Forest Hills",
     "Fresh Meadows",
     "Glen Oaks",
     "Glendale",
     "Hillcrest",
     "Hollis",
     "Holliswood",
     "Howard Beach",
     "JFK Airport",
     "Jackson Heights",
     "Jamaica",
     "Jamaica Estates",
     "Jamaica Hills",
     "Kew Gardens",
     "Kew Gardens Hills",
     "LaGuardia Airport",
     "Laurelton",
     "LeFrak City",
     "Lindenwood",
     "Little Neck",
     "Long Island City",
     "Malba",
     "Maspeth",
     "Middle Village",
     "Murray Hill",
     "North Corona",
     "Oakland Gardens",
     "Ozone Park",
     "Pomonok",
     "Queens Village",
     "Queensborough Hill",
     "Rego Park",
     "Richmond Hill",
     "Ridgewood",
     "Rochdale",
     "Rockaway Park",
     "Rosedale",
     "Seaside",
     "Somerville",
     "Springfield Gardens",
     "Steinway",
     "Sunnyside",
     "Utopia",
     "Whitestone",
     "Woodhaven",
     "Woodside"].each do |name|
      Neighborhood.create(:name => name,
                          :city => "New York",
                          :state => "NY",
                          :country => "USA",
                          :borough => "Queens")
    end

    ["Annadale",
     "Arden Heights",
     "Arlington",
     "Arrochar",
     "Bay Terrace",
     "Bloomfield",
     "Bullshead",
     "Castleton Corners",
     "Charleston",
     "Chelsea",
     "Clifton",
     "Concord",
     "Dongan Hills",
     "Elm Park",
     "Eltingville",
     "Emerson Hill",
     "Graniteville",
     "Grant City",
     "Grasmere",
     "Great Kills",
     "Grymes Hill",
     "Heartland Village",
     "Howland Hook",
     "Huguenot",
     "Lighthouse Hill",
     "Mariner",
     "Midland Beach",
     "New Brighton",
     "New Dorp",
     "New Dorp Beach",
     "New Springville",
     "Oakwood",
     "Old Town",
     "Park Hill",
     "Pleasant Plains",
     "Port Richmond",
     "Princes Bay",
     "Randall Manor",
     "Richmond Town",
     "Richmond Valley",
     "Rosebank",
     "Rossville",
     "Shore Acres",
     "Silver Lake",
     "St. George",
     "Stapleton",
     "Sunnyside",
     "Todt Hill",
     "Tompkinsville",
     "Tottenville",
     "West Brighton",
     "Westerleigh",
     "Woodrow"].each do |name|
      Neighborhood.create(:name => name,
                          :city => "New York",
                          :state => "NY",
                          :country => "USA",
                          :borough => "Staten Island")
    end

    Feature.create(:name => "furnished", :category => "apartment")
    Feature.create(:name => "exposed brick", :category => "apartment")
    Feature.create(:name => "sleeping loft", :category => "apartment")
    Feature.create(:name => "high ceilings", :category => "apartment")
    Feature.create(:name => "air conditioning", :category => "apartment")
    Feature.create(:name => "backyard", :category => "apartment")
    Feature.create(:name => "balcony", :category => "apartment")
    Feature.create(:name => "bathtub", :category => "apartment")
    Feature.create(:name => "dishwasher", :category => "apartment")
    Feature.create(:name => "washer/dryer", :category => "apartment")

    Feature.create(:name => "high-rise", :category => "building")
    Feature.create(:name => "live-in super", :category => "building")
    Feature.create(:name => "doorman", :category => "building")
    Feature.create(:name => "elevator", :category => "building")
    Feature.create(:name => "gym", :category => "building")
    Feature.create(:name => "pool", :category => "building")
    Feature.create(:name => "roof deck", :category => "building")
    Feature.create(:name => "washer/dryer", :category => "building")

    Feature.create(:name => "cats allowed", :category => "pet")
    Feature.create(:name => "dogs allowed", :category => "pet")
    Feature.create(:name => "case-by-case", :category => "pet")
  end
end
