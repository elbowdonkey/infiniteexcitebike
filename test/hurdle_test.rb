require 'test/unit'
require_relative '../hurdle.rb'

class HurdleTest < Test::Unit::TestCase
	def test_hurdle_paths
		hurdle = HurdleA.new
		expected_path = [
			{x: 1,  y: -1},
			{x: 2,  y: -2},
			{x: 3,  y: -3},
			{x: 4,  y: -4},
			{x: 5,  y: -5},
			{x: 6,  y: -6},
			{x: 7,  y: -7},
			{x: 8,  y: -8},
			{x: 9,  y: -9},
			{x: 10, y: -10},
			{x: 11, y: -11},
			{x: 12, y: -10},
			{x: 13, y: -9},
			{x: 14, y: -8},
			{x: 15, y: -7},
			{x: 16, y: -6},
			{x: 17, y: -5},
			{x: 18, y: -4},
			{x: 19, y: -3},
			{x: 20, y: -2},
			{x: 21, y: -1}
		]

		assert_equal(expected_path, hurdle.paths[0])
	end
end