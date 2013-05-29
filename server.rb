require 'rubygems'
require 'sinatra'
require 'em-websocket'
require 'thin'
require 'nokogiri'
require 'json'
require 'uuid'
require 'pp'

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

  class App < Sinatra::Base
    get '*' do
      path = params[:splat][0]
      path = "/index.html" if path == "/"
      #"#{path}"
      File.open("." + path, "r").read
    end
  end

  EM::WebSocket.start(opts) do |conn|
    conn.onopen    { game.add_player conn }
    conn.onmessage {|m| game.process_input(conn, m) }
    conn.onclose   { game.remove_player conn }
  end

  App.run!({:port => 3000})
end

