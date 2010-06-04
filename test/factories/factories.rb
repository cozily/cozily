Factory.define :address do |a|
  a.full_address  "546 Henry St 11231"
end

Factory.define :apartment do |a|
  a.association     :address
  a.rent            1500
  a.bedrooms        1
  a.bathrooms       1
  a.square_footage  500
  a.description     Faker::Lorem.paragraph(1)
end

Factory.define :favorite do |f|
  f.association  :user
  f.association  :apartment
end