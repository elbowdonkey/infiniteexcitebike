class Game
  include EM::Deferrable
  attr_accessor :players, :frame, :connections, :track

  def initialize(options={})
    @connections = options[:connections] || []
    @players     = options[:players]     || []
    @track       = Track.new
    @frame       = 0
  end

  def advance_frames
    @frame += 1
  end

  def process_input(connection, message)
    player = find_player_by_sig(connection.signature)

    case message["input"]
    when "right"
      player.apply_throttle

    when "left"
      player.apply_brake

    when "coast"
      player.coast

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

  def find_player_by_client(client_id)
    return @players.detect do |p|
      p.client_id == client_id
    end
  end

  def find_player_by_sig(signature)
    return @players.detect do |p|
      p.signature == signature
    end
  end

  def remove_player(connection)
    player = find_player_by_sig(connection.signature)
    @players.delete player
    message = {
      :remove => player.client_id
    }
    broadcast(message)
  end

  def broadcast(message)
    @players.each do |player|
      player.send_message message
    end
  end
end
