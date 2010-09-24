include Padlock

Padlock(Rails.env) do
  disable :tweet_apartments, :in => [:development, :test, :cucumber, :staging, :production]
end
