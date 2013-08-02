require 'rubygems'
require 'sinatra'
require 'em-websocket'
require 'thin'
require 'nokogiri'
require 'json'
require 'uuid'
require 'pp'
require 'pry'
require 'eshq'

require_relative 'broker.rb'
require_relative 'game.rb'
require_relative 'hurdle.rb'
require_relative 'track.rb'
require_relative 'player.rb'


EM.run do
  class App < Sinatra::Base
    get '*' do
      path = params[:splat][0]
      path = "/index.html" if path == "/"

      file_ext = path.split(".").last

      case file_ext
      when "js"
        content_type "application/javascript"
      when "png"
        content_type "image/png"
      when "html"
        content_type "text/html"
      end

      File.open("." + path, "r").read
    end

    post "/eshq/socket" do
      socket = ESHQ.open(:channel => params[:channel])
      content_type :json
      {:socket => socket}.to_json
    end


  end

  broker = Broker.new "foo"
  game   = Game.new broker

  #broker.start(:game)
  #broker.start(:players)
  #broker.start(:input)


  # Run static assets server
  App.run!
end

