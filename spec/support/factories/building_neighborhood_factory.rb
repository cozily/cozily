FactoryGirl.define do
  factory :building_neighborhood do
    association  :building
    association  :neighborhood
  end
end
