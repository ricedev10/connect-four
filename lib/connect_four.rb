# frozen-string-literal: true

# Command line interface game for playing connect against computer or other player
class ConnectFour
  def initialize(columns = 7, rows = 6)
    @grid = make_grid(columns, rows)
  end

  def drop_disk(column, id)
    unless column.between?(
      0, @grid.count - 1
    )
      raise RangeError,
            "column #{column} is out of range. Must be between 0 and #{@grid.count - 1}"
    end

    raise RangeError, "column #{column} already has maximum disks" unless @grid[column].last.nil?

    @grid[column].each_index do |i|
      @grid[column][i] = id and break if @grid[column][i].nil?
    end
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
