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

host = '0.0.0.0'
opts = {
  host: host,
  port: 9000
}

EM.run do
  game = Game.new

  EM.start_server(host, 3000, ContentHandler)


  EM::WebSocket.start(opts) do |conn|
    conn.onopen    { game.add_player conn }
    conn.onmessage {|m| game.process_input(conn, m) }
    conn.onclose   { game.remove_player conn }
  end
end