FactoryGirl.define do
  factory :message do
    association  :conversation
    association  :sender, :factory => :user
    body         { Faker::Lorem.paragraph }
  end
end
