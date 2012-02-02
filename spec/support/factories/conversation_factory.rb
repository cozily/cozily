FactoryGirl.define do
  factory :conversation do
    association  :apartment, :factory => :published_apartment
    association  :sender, :factory => :user
    association  :receiver, :factory => :user
    body         { Faker::Lorem.paragraph }
  end
end
