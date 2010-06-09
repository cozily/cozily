Factory.define :address do |a|
  a.full_address  "546 Henry St 11231"
end

Factory.define :apartment do |a|
  a.association     :address
  a.rent            1500
  a.bedrooms        1
  a.bathrooms       1
  a.square_footage  500
end

Factory.define :apartment_feature do |a|
  a.association  :apartment
  a.association  :feature
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