class Integer
  def limit(min,max)
    val = self
    val = (self < min ? min : max) unless (min..max).member? self
    val
  end
end

class Player
  attr_accessor :connection, :game, :client_id, :signature, :position, :tick, :lane, :throttle_level, :throttle_counter, :throttle_steps

  def initialize(options={})
    @connection = options[:connection]
    @game       = options[:game]
    @client_id  = options[:client_id]
    @position   = options[:position] || {x: 0, y: 0}
    @lane       = options[:lane] || 2
    @signature  = @connection.signature
    @tick      = 0

    @throttle_level   = 0
    @throttle_counter = 0
    @throttle_steps   = [0,8,16,32]
  end

  def to_hash
    @position = plot_circle # for fun!
    {
      game_id:   @game.object_id,
      client_id: @client_id,
      signature: @signature,
      position:  @position
    }
  end

  def apply_throttle
    set_new_position :right
  end

  def apply_brake
    set_new_position :left
  end

  def lane_up
    change_lanes :up
  end

  def lane_down
    change_lanes :down
  end

  def change_lanes(direction)
    @lane -= 1 if direction == :up
    @lane += 1 if direction == :down
    @lane = 0  if @lane < 0
    @lane = 3  if @lane > 3
    @lane
  end

  def set_new_position(direction)
    right = direction == :right
    left = direction == :left

    @throttle_level = 0 if @throttle_counter >= @throttle_steps[0]
    @throttle_level = 1 if @throttle_counter >= @throttle_steps[1]
    @throttle_level = 2 if @throttle_counter >= @throttle_steps[2]
    @throttle_level = 3 if @throttle_counter >= @throttle_steps[3]

    if right
      @throttle_counter += 1
    else
      @throttle_counter -= 1
    end

    @throttle_counter = @throttle_counter.limit(0,32)
    @throttle_level = @throttle_level.limit(0,3)

    @position[:x] += @throttle_level if right
    @position[:x] -= 1 if left
  end

  def send_message(message)
    connection.send(message.to_json)
  end

  def plot_circle
    cx = 640/2
    cy = 480/2
    rad = 150
    speed = 2
    speed_scale = (0.001*2*Math::PI)/speed

    angle = @tick * speed_scale
    x = cx + Math.sin(angle) * rad
    y = cy + Math.cos(angle) * rad
    {:x => x, :y => y}
  end
end