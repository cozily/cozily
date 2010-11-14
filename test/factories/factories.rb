Factory.define :address do |a|
  a.full_address  { Factory.next :full_address }
end

Factory.define :address_neighborhood do |a|
  a.association  :address
  a.association  :neighborhood
end

Factory.define :apartment do |a|
  a.association     :address
  a.association     :user
  a.unit            { (rand(100) + 1).to_s }
  a.rent            1500
  a.bedrooms        1
  a.bathrooms       1
  a.square_footage  500
  a.start_date      1.month.from_now
end

Factory.define :published_apartment, :parent => :apartment do |a|
  a.state  'published'
  a.after_create do |apartment|
    2.times { Factory(:image, :apartment => apartment) }
  end
end

Factory.define :apartment_feature do |a|
  a.association  :apartment
  a.association  :feature
end

Factory.define :conversation do |m|
  m.association  :apartment, :factory => :published_apartment
  m.association  :sender, :factory => :email_confirmed_user
  m.association  :receiver, :factory => :email_confirmed_user
  m.body         { Faker::Lorem.paragraph }
end

Factory.define :favorite do |f|
  f.association  :user
  f.association  :apartment, :factory => :published_apartment
end

Factory.define :feature do |f|
  f.name  Faker::Lorem.words(1)
end

Factory.define :flag do |f|
  f.association  :user
  f.association  :apartment, :factory => :published_apartment
end

Factory.define :image do |i|
  i.association  :apartment
end

Factory.define :message do |m|
  m.association  :conversation
  m.association  :sender, :factory => :email_confirmed_user
  m.body         { Faker::Lorem.paragraph }
end

Factory.define :neighborhood do |n|
  n.name { ["Upper West Side", "Greenpoint", "Williamsburg"].rand }
end

Factory.define :neighborhood_profile do |n|
  n.association :neighborhood
  n.association :profile
end

Factory.define :profile do |p|
  p.bedrooms     { rand(8) }
  p.rent         { 1000 + 100*rand(20) }
  p.association  :user
end

Factory.define :role do |r|
  r.name  { Faker::Lorem.words }
end

Factory.define :station do |s|
  s.name  "W 215 St"
  s.lat   40.869555
  s.lng   -73.915163
end

Factory.define :timeline_event do |t|
  t.association  :actor, :factory => :user
end

Factory.define :user_activity do |u|
  u.association :user
  u.date        { Date.today }
end

Factory.define :user_role do |u|
  u.association  :user
  u.association  :role
end

Factory.sequence :full_address do |n|
  addresses = ["546 Henry St 11231", "151 Huron St 11222", "99 S 3rd St 11211", "111 W 74th St 10023", "268 Bowery 10012"]
  addresses[n % addresses.length]
end
