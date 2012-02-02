FactoryGirl.define do
  factory :profile_feature do
    association  :profile
    association  :feature
  end
end
