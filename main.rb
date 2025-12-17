require_relative 'lib/connect_four'
require_relative 'lib/player'

player = Player.new(1..7) { |x| x - 1 }

game = ConnectFour.new
game.play(player, player)
