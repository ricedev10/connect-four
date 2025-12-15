require_relative '../lib/connect_four'

describe ConnectFour do
  subject(:game) { described_class.new }
  describe '#initialize' do
    matcher :be_2d_array_of do |length, width|
      match do |array|
        array.count == length && array.all? { |a| a.count == width }
      end
    end
    it 'has default 2d array of 7x6' do
      grid = game.instance_variable_get(:@grid)
      expect(grid).to be_2d_array_of(7, 6)
    end
  end
end
