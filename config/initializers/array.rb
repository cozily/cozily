class Array
  def as_json(options = {})
    self.collect do |el|
      el.as_json(options)
    end
  end

  def median
    compact!
    sort!

    return 0 if self.length.zero?
    return self.first if self.length == 1

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
