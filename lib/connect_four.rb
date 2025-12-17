# frozen-string-literal: false

require 'colorize'

# Command line interface game for playing connect against computer or other player
class ConnectFour
  attr_reader :winner, :player1, :player2

  def initialize(columns = 7, rows = 6)
    @grid = make_grid(columns, rows)
    @winner = nil
    @player1 = "\u26AA"
    @player2 = "\u26AB"
    @next_player = @player1

    @columns = columns
    @rows = rows
  end

  def drop_disk(column, player = @next_player)
    valid, msg = valid_column?(column)
    raise StandardError, msg unless valid

    @grid[column].each_index do |row|
      next unless @grid[column][row].nil?

      @grid[column][row] = player
      check_winner(column, row)
      break
    end

    @next_player = @next_player == @player1 ? @player2 : @player1
  end

  def play(player1, player2)
    next_player = player1
    while @winner.nil?
      puts self
      puts "Enter a column (#{@next_player}): "
      column = next_player.get
      drop_disk(column)

      next_player = next_player == player1 ? player2 : player1
    end

    puts self
    puts "#{@winner} has won!"
  end

  def to_s # rubocop:disable Metrics/MethodLength
    out = ''
    @rows.times do |row|
      @columns.times do |column|
        # each row (X | X | X ...)
        # start from top most row when adding to string
        out << " #{@grid[column][@rows - row - 1] || '  '} |"
      end
      out << "\n"
    end

    # Bottom line
    @columns.times { out << '-----' }

    # Numbering for each column
    out << "\n"
    @columns.times { |i| out << "  #{i + 1} |" }

    out
  end

  private

  def rows_at(index = 0)
    row = []
    @grid.each do |column|
      row << column[index]
    end

    row
  end

  def find_winner_at(values)
    last = nil
    count = 1

    values.each do |e|
      last == e && !e.nil? ? count += 1 : count = 1
      last = e

      @winner = last and return true if count == 4
    end

    false
  end

  def check_winner(last_column, last_row)
    # check column
    column = @grid[last_column]
    return if find_winner_at(column)

    # check row
    return if find_winner_at(rows_at(last_row))

    # check diagonal
    left_most = last_column
    bottom_most = last_row

    left_most -= 1 and bottom_most -= 1 while left_most.positive? && bottom_most.positive?

    diagonal = []
    while left_most < @columns && bottom_most < @rows
      slot = @grid[left_most][bottom_most]
      diagonal << slot
      left_most += 1
      bottom_most += 1
    end

    find_winner_at(diagonal)
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
