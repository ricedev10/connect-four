# frozen-string-literal: true

# Player class for connect four game. Receives user input
class Player
  def initialize(range)
    @range = range
  end

  def get # rubocop:disable Metrics/MethodLength
    while (num = gets.chomp)
      unless /^-?[0-9]*$/.match?(num)
        puts invalid_input
        next
      end

      unless @range.include?(num.to_i)
        puts(out_of_range(num))
        next
      end

      return num.to_i
    end
  end

  private

  def invalid_input
    "Invalid input - must be a number between #{@range.first} and #{@range.last}"
  end

  def out_of_range(num)
    "Invalid number - (#{num}) must be between #{@range.first} and #{@range.last}"
  end
end
