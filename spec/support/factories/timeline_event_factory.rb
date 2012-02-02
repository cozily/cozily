FactoryGirl.define do
  factory :timeline_event do
    association  :actor, :factory => :user
  end
end
