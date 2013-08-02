class Broker
  attr_accessor :connection

  # subscribes to message queue
  # publishes game state changes
  # - player joins
  # - player disconnects
  # - player state changes

  def initialize(connection)
    @connection = connection
    @clients = []
    @channels = {}
    #establish_channels
  end

  # def establish_channels
  #   # setup player join/exit channel
  #   # - clients subscribe to this channel and handle joins exits
  #   #   "out of band" - meaning, no need to wait for this server
  #   create_channel :players

  #   # setup a channel that players can only publish to
  #   # - this server subscribes to that channel and acts on the messages in that queue
  #   # - player input goes on this channel, for example
  #   create_channel :input

  #   # setup a channel that players can only subscribe to
  #   # - this server publishes game state to this channel
  #   create_channel :game
  # end

  # def create_channel(channel_key)
  #   @channels[channel_key] = AMQP::Channel.new @connection
  # end

  # def start(channel_key)
  #   queue = @channels[channel_key].queue("excitebike.#{channel_key.to_s}", :exclusive => true)
  #   queue.subscribe(&self.method(:act_on_channel_messages))
  # end

  # def act_on_channel_messages(metadata, payload)
  #   # depending on the queue architecture, this might happen in a different ways
  #   # this is where we "respond" to messages in the "player input" channel
  #   # we might also publish to the game state channel here
  #   puts "Received a message: #{payload}, content_type = #{metadata.content_type}"
  # end

  # def broadcast(message)
  #   @channels[:game].default_exchange.publish(message, :routing_key => "excitebike.game")
  # end
end