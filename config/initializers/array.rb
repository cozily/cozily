class Array
  def as_json(options = {})
    self.collect do |el|
      el.as_json(options)
    end
  end
end
