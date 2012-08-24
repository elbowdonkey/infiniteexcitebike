class Track
  attr_accessor :hurdles
  @@hurdle_types = [HurdleA, HurdleB]

  def initialize(options={})
  	@hurdles = []
  	spawn_starting_hurdles
  end

  def spawn_random_hurdle
    position = {x: 0, y: 0} if @hurdles.length == 0
    position =  next_pos_hurdle_pos if @hurdles.length > 0

  	@@hurdle_types.sample.new(position: position)
  end

  def spawn_starting_hurdles
  	10.times do
  		@hurdles << spawn_random_hurdle
  	end
  end

  def next_pos_hurdle_pos
    {
      x: @hurdles.last.position[:x] + 100,
      y: @hurdles.last.position[:y]
    }
  end

  def hurdles_to_hash
    hash = {}
    @hurdles.each do |hurdle|
      hash[hurdle.id] = hurdle.to_hash
    end
    return hash
  end
end