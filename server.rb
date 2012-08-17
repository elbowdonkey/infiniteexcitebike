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
EM.run do
  puts "Server started on 0.0.0.0:9000"
  game = Game.new

  EM::WebSocket.start(:host => '0.0.0.0', :port => 9000) do |connection|
    game.connection = connection

    connection.onopen do
      player = game.add_player
    end

    connection.onmessage do |message|
      game.process_input(JSON.parse(message))

      game.callback do |response|
        connection.send(response.to_json)
      end
    end

    # game.players.each do |player|
    #   EM.add_periodic_timer(1.0) do
    #     puts "saying hi..."
    #     connection.send("Player #{player.signature} says hi.")
    #   end
    # end

    connection.onclose { puts "closed" }
    connection.onerror { |e| puts "err #{e.inspect}" }

    #EM.add_periodic_timer(0.0167) do
    EM.add_periodic_timer(1.0) do
      # game.frame += 1

      # if (game.frame > 32)
      #   game.frame = 1
      # end

      connection.send({:advance => true}.to_json)
    end
  end
end