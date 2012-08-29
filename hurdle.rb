class Hurdle
  attr_accessor :position, :kind, :width, :paths

  def initialize(options={})
    @position ||= options[:position]
    @kind = self.class
    @paths = []
    4.times{|i| @paths << calculate_path(i+1)}
  end

  def id
    "hurdle_#{@position[:x]}_#{object_id}"
  end

  def to_hash
    {
      id:       id,
      game_id:  @game.object_id,
      width:    @width,
      paths:    @paths,
      position: @position,
      kind:     @kind
    }
  end

  def calculate_path(throttle_level)
    x = 0
    y = 0
    airtime = throttle_level
    apex_height = @height + airtime
    path = []

    @height.times do
      x += (@rise[0] * throttle_level)
      y += (@rise[1] * throttle_level)
      path << {x: x, y: y}
    end

    airtime.times do |i|
      x += (@rise[0] * throttle_level)
      y += (@rise[1] * throttle_level) if y < @height + airtime
      path << {x: x, y: y}
    end

    @height.times do |i|
      x += (@rise[0] * throttle_level)
      y -= (@rise[1] * throttle_level)
      path << {x: x, y: y}
    end
    path
  end
end

class HurdleA < Hurdle
  def initialize(options={})
    @rise = [1,-1]
    @width = 24
    @height = 10

    super(options)
  end
end

class HurdleB < Hurdle
  def initialize(options={})
    @rise = [1,-1]
    @width = 40
    @height = 18

    super(options)
  end
end

# class BezierPoint
#   def self.create(bump_1_x, bump_1_y, pull_1_x, pull_1_y, pull_2_x, pull_2_y, bump_2_x, bump_2_y)
#     [
#       {
#        bump: {x: bump_1_x, y: bump_1_y}
#       },
#       {
#         pull1: {x: pull_1_x, y: pull_1_y},
#         pull2: {x: pull_2_x, y: pull_2_y},
#         bump: {x: bump_2_x, y: bump_2_y},
#         inc: 0.04
#       }
#     ]
#   end
# end