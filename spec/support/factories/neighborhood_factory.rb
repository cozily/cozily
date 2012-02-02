FactoryGirl.define do
  factory :neighborhood do
    name { ["Upper West Side", "Greenpoint", "Williamsburg"].sample }
  end
end
