class Motor
  def intialize
    @running = false
  end
  def self.on(status)
    @running = status
  end
  def self.running?
    return @running
  end
end
