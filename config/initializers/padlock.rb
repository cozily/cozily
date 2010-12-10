include Padlock

Padlock(Rails.env) do
  disable :activity_feed, :in => [:development, :test, :staging, :production]
  disable :tweet_apartments, :in => [:development, :test, :staging, :production]
end
