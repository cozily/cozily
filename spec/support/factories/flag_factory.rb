FactoryGirl.define do
  factory :flag do
    association  :user
    association  :apartment, :factory => :published_apartment
  end
end
