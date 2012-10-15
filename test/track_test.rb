require 'test/unit'
require_relative '../hurdle.rb'
require_relative '../track.rb'

class TrackTest < Test::Unit::TestCase
	def test_next_pos_hurdle_pos
		track = Track.new
		assert_equal(10, track.hurdles.length)
		assert_equal({x: 0, y: 0}, track.hurdles[0].position)
		assert_equal({x: 60, y: 0}, track.hurdles[1].position)
	end
end