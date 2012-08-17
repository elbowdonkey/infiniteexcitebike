class Game
  include EM::Deferrable
  attr_accessor :connection, :players, :frame, :points, :paused

  def initialize(options={})
    puts "creating a new game object"
    @players = options[:players] || []
    @frame = 0
    @paused = false
  end

  def process_input(message)
    player = Player.find(message["client_id"], self)

    case message["input"]
      when "throttle"
        player.apply_throttle

      when "brake"
        player.apply_brake

      when "up"
        player.lane_up

      when "down"
        player.lane_down

    end

    results = {
      :position => player.position
    }

    succeed(results)
  end

  def add_player
    player = Player.new(:connection => @connection, :game => self)
    @players << player
    @connection.send({:players => @players.collect {|p| {:client_id => p.client_id}}}.to_json)
    player
  end

  def plot_circle
    cx = 640/2
    cy = 480/2
    rad = 200
    speed = 0.5
    speed_scale = (0.001*2*Math::PI)/speed

    angle = @frame * speed_scale
    x = cx + Math.sin(angle) * rad
    y = cy + Math.cos(angle) * rad
    [x,y]
  end
end