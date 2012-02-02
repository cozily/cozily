FactoryGirl.define do
  factory :profile do
    bedrooms     { rand(8) }
    rent         { 1000 + 100*rand(20) }
    association  :user
  end
end
