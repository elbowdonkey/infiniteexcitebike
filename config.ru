require 'rubygems'
require 'em-websocket'
require 'thin'
require 'nokogiri'
require 'json'
require 'uuid'
require 'pp'
require 'amqp'
require 'amqp/extensions/rabbitmq'
require "rack/sockjs"
require "pry"

require './fake_sinatra.rb'

require './broker.rb'
require './game.rb'
require './hurdle.rb'
require './track.rb'
require './player.rb'

ampq_url = 'amqp://8yAO4imo:4bXdN3zlYdVh03m0NJGXd9J7qJ8NwEWc@sad-woundwort-5.bigwig.lshift.net:10448/8IgXWvZ0g8lU'

class StaticAssets
  def call(env)
    path = env["PATH_INFO"]
    path = "/index.html" if path == "/"

    file_ext = path.split(".").last

    case file_ext
    when "js"
      content_type = "application/javascript"
    when "png"
      content_type = "image/png"
    when "html"
      content_type = "text/html"
    end

    body = File.open(File.dirname(__FILE__) + path, "r").read
    [200, {"Content-Type" => content_type}, [body]]
  end
end

EM.run do
  thin = Rack::Handler.get("thin")

  app = Rack::Builder.new do
    # use Rack::SockJS, :prefix => "/phil" do |connection|
    #   [200, {"Content-Type" => "text/html"}, ["foo"]]
    # end

    use Rack::SockJS, :prefix => "/echo" do |connection|
      connection.subscribe do |session, message|
        session.send(message)
      end
    end

    use Rack::SockJS, :prefix => "/close" do |connection|
      connection.session_open do |session|
        session.close(3000, "Go away!")
      end
    end

    map "/" do
      binding.pry
      puts "I HAPPEN"
    end

    run StaticAssets
  end

  thin.run(app, Port: 8081)

  AMQP.start(ampq_url) do |connection, open_ok|
    broker = Broker.new connection
    game   = Game.new broker

    broker.start(:game)
    broker.start(:players)
    broker.start(:input)

    broker.broadcast("HELLO MOTO")
  end
end