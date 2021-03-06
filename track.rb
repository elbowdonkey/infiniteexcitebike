class Track
  attr_accessor :hurdles, :width

  @@hurdle_types = [HurdleA, HurdleB, HurdleC, HurdleD]
  @@minimum_hurdle_spacing = 200
  @@start_pos = 100

  def initialize
  	@hurdles = []
  	spawn_starting_hurdles
    @width = @hurdles.last.position[:x] + @hurdles.last.width
  end

  def spawn_random_hurdle
    position = {x: @@start_pos, y: -32} if @hurdles.length == 0
    position =  next_pos_hurdle_pos if @hurdles.length > 0
    hurdle_class = @@hurdle_types.sample
  	hurdle_class.new(position: position)
  end

  def spawn_starting_hurdles
  	10.times do
  		@hurdles << spawn_random_hurdle
  	end
  end

  def next_pos_hurdle_pos
    random_spacing = rand(100)
    last_hurdle = @hurdles.last
    {
      x: last_hurdle.position[:x] + last_hurdle.width + @@minimum_hurdle_spacing + random_spacing,
      y: last_hurdle.position[:y]
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