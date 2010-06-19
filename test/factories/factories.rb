Factory.define :address do |a|
  a.full_address  "546 Henry St 11231"
end

Factory.define :apartment do |a|
  a.association     :address
  a.association     :contact
  a.association     :user
  a.unit            { (rand(100) + 1).to_s }
  a.rent            1500
  a.bedrooms        1
  a.bathrooms       1
  a.square_footage  500
  a.start_date      1.month.from_now
end

Factory.define :apartment_feature do |a|
  a.association  :apartment
  a.association  :feature
end

Factory.define :contact do |c|
  c.association  :user
  c.name         Faker::Name.name
  c.email        Faker::Internet.email
end

Factory.define :favorite do |f|
  f.association  :user
  f.association  :apartment
end

Factory.define :feature do |f|
  f.name  Faker::Lorem.words(1)
end

Factory.define :flag do |f|
  f.association  :user
  f.association  :apartment
end

Factory.define :image do |f|
  f.association  :apartment
end

Factory.define :station do |s|
  s.name  "W 215 St"
  s.lat   40.869555
  s.lng   -73.915163
end