class Player
  attr_accessor :connection, :game, :client_id, :signature, :position

  def self.find(client_id, game)
    game.players.detect{|player| player.client_id == client_id}
  end

  def initialize(options={})
    @connection = options[:connection] || nil
    @game = options[:game]
    @signature = @connection.signature
    @position = {x: 0, y: 0}

    generate_client_id
  end

  def generate_client_id
    @client_id = UUID.new.generate
    response = {:signature => @signature, :client_id => @client_id}
    @connection.send(response.to_json)
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
end