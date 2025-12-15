# frozen-string-literal: true

# Command line interface game for playing connect against computer or other player
class ConnectFour
  def initialize(columns = 7, rows = 6)
    @grid = make_grid(columns, rows)
  end

  private

  def make_grid(x, y) # rubocop:disable Naming/MethodParameterName
    grid = []
    x.times do |_|
      y_grid = []
      y.times do |_|
        y_grid << nil
      end

      grid << y_grid
    end

    grid
  end
end
