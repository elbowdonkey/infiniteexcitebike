class Game
  include EM::Deferrable
  attr_accessor :players, :frame, :points, :paused, :connections

  def initialize(options={})
    @connections = options[:connections] || []
    @players     = options[:players] || []
    @frame       = 0
    @paused      = false
  end

  def process_input(connection, message)
    player = find_player(connection)

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

    succeed(player.to_hash)
  end

  def add_player(connection)
    player = Player.new(:game => self, :client_id => UUID.new.generate, :connection => connection)
    @players << player

    player.send_message(player.to_hash)
    #broadcast({:players => @players.collect {|p| p.to_hash }})
  end

  def find_player(connection)
    return @players.detect do |p|
      p.signature == connection.signature
    end
  end

  def broadcast(message)
    @players.each do |player|
      player.send_message message
    end
  end
end
