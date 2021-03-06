class Game
  include EM::Deferrable
  # http://eventmachine.rubyforge.org/EventMachine/Deferrable.html
  @@frame_length = 0.0167
  attr_accessor :players, :connections, :track, :broker

  def initialize(broker)
    @broker      = broker
    @connections = []
    @players     = []
    @track       = Track.new
    #setup_timer
  end

  def setup_timer
    EM.add_periodic_timer(@@frame_length) do
      @broker.broadcast(
        :advance => true,
        :game => {
          :players => players_to_hash,
          :hurdles => track.hurdles_to_hash,
          :track => {
            :width => track.width
          }
        }
      )
    end
  end

  def process_input(connection, message)
    message = JSON.parse(message)
    player = find_player connection
    player.process_input message["input"]

    succeed(player.to_hash)
  end

  def add_player(connection)
    player = Player.new(
      :game => self,
      :client_id => UUID.new.generate,
      :connection => connection
    )
    @players << player

    player.send_message(player.to_hash)
  end

  def remove_player(connection)
    player = find_player(connection)
    @players.delete player
    broadcast(:remove => player.client_id)
  end

  def broadcast(message={})
    @players.each do |player|
      player.send_message message
    end
  end

  def players_to_hash
    hash = {}
    @players.each do |player|
      hash[player.client_id] = player.to_hash
    end
    return hash
  end

  def find_player(connection)
    return @players.detect do |player|
      player.signature == connection.signature
    end
  end
end