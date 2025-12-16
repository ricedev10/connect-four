# Command line interface game for playing connect against computer or other player
class ConnectFour
  attr_reader :winner

  def initialize(columns = 7, rows = 6)
    @grid = make_grid(columns, rows)
    @winner = nil
    @columns = columns
    @rows = rows
  end

  def drop_disk(column, id)
    valid, msg = valid_column?(column)
    raise StandardError, msg unless valid

    @grid[column].each_index do |row|
      next unless @grid[column][row].nil?

      @grid[column][row] = id
      check_winner(column, row)
      break
    end
  end

  def to_s
    out = ''
    @rows.times do |row|
      @columns.times do |column|
        # each row (X | X | X ...)
        # start from top most row when adding to string

        out << "#{@grid[column][@rows - row - 1] || '___'} | "
      end
      out << "\n"
    end

    out
  end

  private

  def each_row_at(index = 0)
    @grid.each do |column|
      yield(column[index])
    end
  end

  def find_winner_at(iterator)
    last = nil
    count = 1

    iterator.call(proc do |e|
      last == e && !e.nil? ? count += 1 : count = 1
      last = e

      @winner = last and return true if count == 4
    end)

    false
  end

  def check_winner(last_column, last_row)
    # check column
    column = @grid[last_column]
    return if find_winner_at(lambda { |b|
      column.each(&b)
    })

    # check row
    return if find_winner_at(lambda { |b|
      each_row_at(last_row, &b)
    })

    # check diagonal
    left_most = last_column
    bottom_most = last_row

    left_most -= 1 and bottom_most -= 1 while left_most.positive? && bottom_most.positive?

    find_winner_at(proc { |b|
      diagonal = @grid[left_most][bottom_most]
      while left_most <= @columns && bottom_most <= @rows
        b.call(diagonal)
        left_most += 1
        bottom_most += 1
      end
    })
  end

  def valid_column?(column)
    unless column.between?(0, @grid.count - 1)
      return false, "column #{column} is out of range. Must be between 0 and #{@grid.count - 1}"
    end

    return false, "column #{column} already has maximum disks" unless @grid[column].last.nil?

    true
  end

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
