require 'rubygems'
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'thin'
require 'nokogiri'
require 'json'
require 'uuid'
require 'pp'

require_relative 'http_server.rb'
require_relative 'request_parser.rb'
require_relative 'game.rb'
require_relative 'hurdle.rb'
require_relative 'track.rb'
require_relative 'player.rb'

counter = 0
frame_length = 0.03 #0.033 #0.033 #1.0 #0.0167 # == 60 fps

EM.run do
  game = Game.new

  EM.start_server('0.0.0.0', 3000, ContentHandler)

  EM::WebSocket.start(:host => '0.0.0.0', :port => 9000) do |connection|
    game.connections << connection

    game.connections.each do |connection|
      connection.onopen do
        puts "New connection: #{connection.signature}"
        game.add_player(connection)
      end

      connection.onmessage do |message|
        game.process_input(connection,JSON.parse(message))

        game.callback do |response|
          connection.send(response.to_json)
        end
      end

      connection.onclose do
        game.remove_player(connection)
      end

      connection.onerror { |e| puts "err #{e.inspect}" }
    end

    EM.add_periodic_timer(frame_length) do
      game.advance_frames

      players = {}
      hurdles = {}

      game.players.each do |player|
        #player.clock += 1
        #player.set_new_position(:coast)
        players[player.client_id] = player.to_hash
      end

      message = {
        :advance => true,
        :game => {
          :players => players,
          :hurdles => game.track.hurdles_to_hash
        }
      }

      game.broadcast(message);
    end
  end
end