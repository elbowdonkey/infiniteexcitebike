class Hurdle
  attr_accessor :position, :kind, :width, :curves

  def initialize(options={})
    @position ||= options[:position]
    @kind = self.class
  end

  def to_hash
    {
      id:       object_id,
      game_id:  @game.object_id,
      width:    @width,
      curves:   @curves,
      position: @position,
      kind:     @kind
    }
  end
end

class HurdleA < Hurdle
  def initialize(options={})
    super(options)
    @width = 24
    @curves = [
      BezierPoint.create(0,0,0,0,15,-30,30,0),
      BezierPoint.create(0,0,0,0,15,-40,40,0),
      BezierPoint.create(0,0,0,0,15,-40,60,0),
      BezierPoint.create(0,0,0,0,15,-50,80,0)
    ]
  end
end

class HurdleB < Hurdle
  def initialize(options={})
    super(options)
    @width = 40
    @curves = [
      BezierPoint.create(0,0,0,0,15,-30,30,0),
      BezierPoint.create(0,0,0,0,15,-40,40,0),
      BezierPoint.create(0,0,0,0,15,-40,60,0),
      BezierPoint.create(0,0,0,0,15,-50,80,0)
    ]
  end
end

class BezierPoint
  def self.create(bump_1_x, bump_1_y, pull_1_x, pull_1_y, pull_2_x, pull_2_y, bump_2_x, bump_2_y)
    [
      {
       bump: {x: bump_1_x, y: bump_1_y}
      },
      {
        pull1: {x: pull_1_x, y: pull_1_y},
        pull2: {x: pull_2_x, y: pull_2_y},
        bump: {x: bump_2_x, y: bump_2_y},
        inc: 0.04
      }
    ]
  end
end