FactoryGirl.define do
  factory :apartment_feature do
    association  :apartment
    association  :feature
  end
end
