FactoryGirl.define do
  factory :user_activity do
    association :user
    date        { Date.today }
  end
end
