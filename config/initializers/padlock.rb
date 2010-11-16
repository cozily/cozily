include Padlock

Padlock(Rails.env) do
  disable :tweet_apartments, :in => [:development, :test, :staging, :production]
end
