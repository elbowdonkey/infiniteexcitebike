class Integer
  def limit(min,max)
    val = self
    val = (self < min ? min : max) unless (min..max).member? self
    val
  end
end

class Player
  @@ground_pos_y = 240
  attr_accessor :connection, :game, :client_id, :signature, :position, :clock, :lane,
                :throttle_level, :throttle_counter, :throttle_steps,
                :at_hurdle, :current_hurdle_path

  def initialize(options={})
    @connection = options[:connection] || nil
    @game       = options[:game]
    @signature  = @connection.signature
    @position   = {x: 0, y: @@ground_pos_y}
    @lane       = options[:lane] || 2
    @client_id  = options[:client_id]
    @clock      = 0
    @at_hurdle  = false

    @throttle_level   = 0
    @throttle_counter = 0
    @throttle_steps   = [0,8,24,56,80]
  end

  def to_hash
    #@position = plot_circle # uncomment for fun!
    {
      game_id:   @game.object_id,
      client_id: @client_id,
      signature: @signature,
      position:  @position,
      lane:      @lane,
      throttle: {
        level: @throttle_level,
        counter: @throttle_counter
      },
      atHurdle: detect_hurdle
    }
  end

  def apply_throttle
    set_new_position :right
  end

  def apply_brake
    set_new_position :left
  end

  def coast
    set_new_position :coast
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

  def calc_throttle_level
    @throttle_level = 0 if @throttle_counter == @throttle_steps[0]
    @throttle_level = 1 if @throttle_counter >  @throttle_steps[0]
    @throttle_level = 2 if @throttle_counter >  @throttle_steps[1]
    @throttle_level = 3 if @throttle_counter >  @throttle_steps[2]
    @throttle_level = 4 if @throttle_counter >  @throttle_steps[3]
    @throttle_level = 5 if @throttle_counter >= @throttle_steps[4]
  end

  def limit_levels
    @throttle_counter = @throttle_counter.limit(0,80)
    @throttle_level = @throttle_level.limit(0,5)
  end

  def set_new_position(direction)
    right = direction == :right
    left  = direction == :left
    coast = direction == :coast

    calc_throttle_level

    if right
      @throttle_counter += 1
    end

    if left || coast
      @throttle_counter -= 1
    end

    limit_levels

    if @at_hurdle
      if @current_hurdle_path.nil?
        @current_hurdle_path = @at_hurdle.paths[@throttle_level-1].clone #@throttle_level-1].clone
      end
    end

    if !@current_hurdle_path.nil? && @current_hurdle_path.length > 0
      point = @current_hurdle_path.shift()
      #@position[:x] += point[:x]
      @position[:y] = @@ground_pos_y + point[:y]
    else
      @current_hurdle_path = nil
      @position[:y] = @@ground_pos_y
    end

    @position[:x] += @throttle_level if coast
    @position[:x] += @throttle_level if right
    @position[:x] -= @throttle_level if left




    # TODO: coast needs to be aware of which direction player was last headed


  end

  def detect_hurdle
    hurdle = @game.track.hurdles.detect do |hurdle|
      hurdle.position[:x] <= position[:x] && hurdle.position[:x] + hurdle.width >= position[:x]
    end

    if hurdle
      @at_hurdle = hurdle
      return hurdle.to_hash
    else
      @at_hurdle = false
      return false
    end
  end

  def send_message(message)
    connection.send(message.to_json)
  end

  def plot_circle
    cx    = 640/2
    cy    = 480/2
    rad   = 150
    speed = 2
    scale = (0.001*2*Math::PI)/speed

    a = @clock * scale
    x = cx + Math.sin(a) * rad
    y = cy + Math.cos(a) * rad

    {:x => x, :y => y}
  end
end
