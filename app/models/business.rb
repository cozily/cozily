class Business
  attr_accessor :distance, :name, :photo_url, :url

  def initialize(options = {})
    self.distance  = options[:distance]
    self.name      = options[:name]
    self.photo_url = options[:photo_url]
    self.url       = options[:url]
  end
end
