require 'rubygems'
require 'eventmachine'
require 'em-websocket'
require 'em-http'
require 'nokogiri'
require 'json'
require 'uuid'
require 'pp'

require_relative 'game.rb'
require_relative 'player.rb'

counter = 0
frame_length = 0.033 #1.0 #0.0167 # == 60 fps

EM.run do
  game = Game.new
  EM::WebSocket.start(:host => '0.0.0.0', :port => 9000) do |connection|
    game.connections << connection

    game.connections.each do |connection|
      connection.onopen do
        game.add_player(connection)
      end

      connection.onmessage do |message|
        game.process_input(connection,JSON.parse(message))

        game.callback do |response|
          connection.send(response.to_json)
        end
      end

      connection.onclose { puts "closed" }
      connection.onerror { |e| puts "err #{e.inspect}" }  
    end

    EM.add_periodic_timer(frame_length) do
      game.frame += 1

      players = {}

      game.players.each do |player|
        player.clock += 1
        players[player.client_id] = player.to_hash
      end

      message = {
        :advance => true,
        :game => {
          :players => players
        }
      }

      game.broadcast(message);
    end
  end
end