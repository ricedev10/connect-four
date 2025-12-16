require_relative 'lib/connect_four'

game = ConnectFour.new
game.drop_disk(2)
game.drop_disk(2)
game.drop_disk(3)
game.drop_disk(0)
puts game
