class Game
  include EM::Deferrable
  attr_accessor :players, :game_tick, :update_tick, :points, :paused, :connections, :input_queue, :input_queue_sequence

  def initialize(options={})
    @connections = options[:connections] || []
    @players = options[:players] || []
    @game_tick = 0
    @update_tick = 0
    @paused = false
    @input_queue = []
    @input_queue_sequence = 0
  end

  def enqueue_input(connection, message)
    puts "Enqueing input."
    p message
    puts ""
    @input_queue_sequence += 1

    player = find_player_by_sig(connection.signature)

    @input_queue << {
      :seq => @input_queue_sequence,
      :client_id => player.client_id,
      :input => message["input"]
    }

    succeed
  end

  def process_input_queue
    queue = @input_queue.clone
    @input_queue = []

    queue.each do |input|
      process_input(input)
    end
    
    results = {}
    
    @players.each do |player|
      results[player.client_id] = player.to_hash
    end

    results
  end

  def process_input(queued_input)
    player = find_player_by_client(queued_input[:client_id])

    case queued_input
      when "right"
        player.apply_throttle

      when "left"
        player.apply_brake

      when "up"
        player.lane_up

      when "down"
        player.lane_down
    end
  end

  def add_player(connection)
    player = Player.new(:game => self, :client_id => UUID.new.generate, :connection => connection)
    @players << player

    player.send_message(player.to_hash)
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