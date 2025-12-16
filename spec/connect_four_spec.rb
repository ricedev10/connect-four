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
    before do
      allow(game).to receive(:check_winner)
    end

    context 'when one disk is added and another disk is added' do
      it 'has different disks' do
        2.times { game.drop_disk(0) }

        grid = game.instance_variable_get(:@grid)
        expect(grid[0][0]).to eq(game.player1)
        expect(grid[0][1]).to eq(game.player2)
      end
    end

    context 'when one disk is added to leftmost column' do
      it 'has a disk in first column' do
        game.drop_disk(0)

        grid = game.instance_variable_get(:@grid)
        player1 = game.instance_variable_get(:@player1)
        expect(grid[0][0]).to eq(player1)
      end
    end

    context 'when two disks are added to leftmost column' do
      before do
        2.times { game.drop_disk(0, game.player1) }
      end

      it 'stacks in the grid array' do
        grid = game.instance_variable_get(:@grid)
        player1 = game.instance_variable_get(:@player1)
        expect(grid[0][0]).to eq(player1)
        expect(grid[0][1]).to eq(player1)
      end
    end
  end

  describe '@winner' do
    context 'when dropping 4 disks in a column' do
      before do
        4.times { game.drop_disk(0, :player1) }
      end

      it 'has a winner' do
        expect(game.winner).to eq(:player1)
      end
    end

    context 'when dropping 4 disks in a row' do
      before do
        4.times do |i|
          game.drop_disk(i, :player1)
        end
      end

      it 'has a winner' do
        expect(game.winner).to eq(:player1)
      end
    end

    context 'when dropping 4 disks on second row on top of random disks' do
      before do
        game.drop_disk(1, :player1)
        game.drop_disk(2, :player2)
        game.drop_disk(3, :player2)
        game.drop_disk(4, :player1)
        4.times { |i| game.drop_disk(i + 1, :player1) }
      end

      it 'has a winner' do
        expect(game.winner).to eq(:player1)
      end
    end

    context 'when dropping 4 disks on top of disk in column' do
      before do
        2.times { game.drop_disk(2, :player2) }
        4.times { game.drop_disk(2, :player1) }
      end

      it 'has player1 winner' do
        expect(game.winner).to eq(:player1)
      end
    end

    context 'when dropping disks diagonally' do
      before do
        game.drop_disk(1, :player1)

        game.drop_disk(2, :player2)
        game.drop_disk(2, :player1)

        2.times { game.drop_disk(3, :player2) }
        game.drop_disk(3, :player1)

        3.times { game.drop_disk(4, :player2) }
        game.drop_disk(4, :player1)
      end
      it 'has a winner' do
        expect(game.winner).to eq(:player1)
      end
    end
  end
end
