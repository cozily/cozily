FactoryGirl.define do
  factory :apartment do
    association     :building
    association     :user, :factory => :lister
    unit            { (rand(100) + 1).to_s }
    rent            1500
    bedrooms        1
    bathrooms       1
    square_footage  500
    start_date      1.month.from_now
  end

  factory :publishable_apartment, :parent => :apartment do
    after_create do |apartment|
      # 2.times { Factory(:photo, :apartment => apartment) }
    end
  end

  factory :published_apartment, :parent => :apartment do
    state  'published'
    after_create do |apartment|
      # 2.times { Factory(:photo, :apartment => apartment) }
    end
  end
end
