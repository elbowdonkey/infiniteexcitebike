class Player
  attr_accessor :connection, :game, :client_id, :signature, :position, :clock

  def initialize(options={})
    @connection = options[:connection] || nil
    @game       = options[:game]
    @signature  = @connection.signature
    @position   = {x: 0, y: 0}
    @client_id  = options[:client_id]
    @clock      = 0
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
    "throttle applied"
  end

  def apply_brake
    "brake applied"
  end

  def lane_up
    "lane up"
  end

  def lane_down
    "lane down"
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
