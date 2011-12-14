FactoryGirl.define do
  sequence :full_address do |n|
    addresses = ["546 Henry St 11231", "151 Huron St 11222", "99 S 3rd St 11211", "111 W 74th St 10023", "268 Bowery 10012"]
    addresses[n % addresses.length]
  end

  factory :address do
    full_address  { Factory.next(:full_address) }
  end

  factory :address_neighborhood do
    association  :address
    association  :neighborhood
  end

  factory :apartment do
    association     :address
    association     :user, :factory => :lister
    unit            { (rand(100) + 1).to_s }
    rent            1500
    bedrooms        1
    bathrooms       1
    square_footage  500
    start_date      1.month.from_now
  end

  factory :publishable_apartment, :parent => :apartment do
    after_create do |apartment|
      2.times { Factory(:image, :apartment => apartment) }
    end
  end

  factory :published_apartment, :parent => :apartment do
    state  'published'
    after_create do |apartment|
      2.times { Factory(:image, :apartment => apartment) }
    end
  end

  factory :apartment_feature do
    association  :apartment
    association  :feature
  end

  factory :conversation do
    association  :apartment, :factory => :published_apartment
    association  :sender, :factory => :email_confirmed_user
    association  :receiver, :factory => :email_confirmed_user
    body         { Faker::Lorem.paragraph }
  end

  factory :favorite do
    association  :user
    association  :apartment, :factory => :published_apartment
  end

  factory :feature do
    name  Faker::Lorem.words(1)
  end

  factory :flag do
    association  :user
    association  :apartment, :factory => :published_apartment
  end

  factory :image do
    association  :apartment
  end

  factory :message do
    association  :conversation
    association  :sender, :factory => :email_confirmed_user
    body         { Faker::Lorem.paragraph }
  end

  factory :neighborhood do
    name { ["Upper West Side", "Greenpoint", "Williamsburg"].sample }
  end

  factory :neighborhood_profile do
    association :neighborhood
    association :profile
  end

  factory :profile do
    bedrooms     { rand(8) }
    rent         { 1000 + 100*rand(20) }
    association  :user
  end

  factory :role do
    name  { Faker::Lorem.words }
  end

  factory :station do
    name  "W 215 St"
    lat   40.869555
    lng   -73.915163
  end

  factory :timeline_event do
    association  :actor, :factory => :user
  end

  factory :user_activity do
    association :user
    date        { Date.today }
  end

  factory :user_role do
    association  :user
    association  :role
  end
end
