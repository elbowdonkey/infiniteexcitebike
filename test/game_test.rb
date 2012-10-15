require 'uuid'
require 'test/unit'
require_relative '../player.rb'

class Connection
	attr_accessor :signature
	def initialize
		@signature = "bar"
	end
end

class Track
	attr_accessor :hurdles
	def initialize
		@hurdles = []
	end
end

class Game
	attr_accessor :track
	def initialize
		@track = Track.new
	end
end

class GameTest < Test::Unit::TestCase
	def test_player
		game = Game.new
		players = []
		players << Player.new(game: game, client_id: UUID.new.generate, connection: Connection.new)
		players << Player.new(game: game, client_id: UUID.new.generate, connection: Connection.new)
		players << Player.new(game: game, client_id: UUID.new.generate, connection: Connection.new)

		#player = Player.new(game: game, client_id: UUID.new.generate, connection: Connection.new)

		p Hash[*players.map { |player|
      [:client_id, player.to_hash]
    }.flatten]

	end
end