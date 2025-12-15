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

  describe '#drop_disk' do
    context 'when one disk is added to leftmost column' do
      it 'has a disk in first column' do
        game.drop_disk(0, :player1)

        grid = game.instance_variable_get(:@grid)
        expect(grid[0][0]).to eq(:player1)
      end
    end

    context 'when two disks are added to leftmost column' do
      before do
        game.drop_disk(0, :player1)
        game.drop_disk(0, :player1)
      end

      it 'stacks in the grid array' do
        grid = game.instance_variable_get(:@grid)
        expect(grid[0][0]).to eq(:player1)
        expect(grid[0][1]).to eq(:player1)
      end
    end
  end
end
