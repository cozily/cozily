Factory.define :address do |a|
  a.full_address  { Factory.next :full_address }
  a.association   :neighborhood
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

Factory.define :image do |i|
  i.association  :apartment
end

Factory.define :message do |m|
  m.association  :apartment
  m.association  :sender, :factory => :user
  m.association  :receiver, :factory => :user
  m.body         Faker::Lorem.paragraph
end

Factory.define :neighborhood do |n|
  n.name { ["Upper West Side", "Greenpoint", "Williamsburg"].rand }
end

Factory.define :station do |s|
  s.name  "W 215 St"
  s.lat   40.869555
  s.lng   -73.915163
end

Factory.sequence :full_address do |n|
  addresses = ["546 Henry St 11231", "151 Huron St 11222", "99 S 3rd St 11211", "111 W 74th St 10023"]
  addresses[n % addresses.length]
end
