class Array
  def as_json(options = {})
    self.collect do |el|
      el.as_json(options)
    end
  end

  def median
    sort!

    n  = (self.length - 1) / 2
    n2 = (self.length) / 2

    if self.length % 2 == 0
      median = (self[n] + self[n2]) / 2
    else
      median = self[n]
    end

    return median
  end
end
