class Track
  attr_accessor :hurdles
  @@hurdle_types = [HurdleA, HurdleB]

  def initialize(options={})
  	@hurdles = []
  	spawn_starting_hurdles
  end

  def spawn_random_hurdle
  	@@hurdle_types.sample.new
  end

  def spawn_starting_hurdles
  	10.times do
  		@hurdles << spawn_random_hurdle
  	end
  end
end