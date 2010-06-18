include Padlock

Padlock(Rails.env) do
  disable :tweet_apartments, :in => :production
end
