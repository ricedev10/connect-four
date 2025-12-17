require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new(0..5) }

  describe '#initialize' do
    subject(:player) { described_class.new(0..5) { |value| value * 2 } }
    context 'when block is provided' do
      before do
        allow(player).to receive(:gets).and_return('2')
      end

      it 'returns 4 when getting 2' do
        expect(player.get).to eql(4)
      end
    end
  end

  describe '#get' do
    context 'when input is valid' do
      before do
        allow(player).to receive(:gets).and_return('2')
      end
      it 'returns the input as a number' do
        expect(player.get).to eql(2)
      end
    end

    context 'when input is invalid then valid' do
      before do
        allow(player).to receive(:gets).and_return('hello', '2')
      end

      it 'returns the number' do
        expect(player.get).to eql(2)
      end
    end

    context 'when input value that is not a number' do
      before do
        allow(player).to receive(:gets).and_return('ab', '2')
      end

      it 'puts "Invalid Input...' do
        expect(player).to receive(:puts).with('Invalid input - must be a number between 0 and 5').once
        player.get
      end
    end

    context 'when input is negative' do
      before do
        allow(player).to receive(:gets).and_return('-1', '4')
      end

      it 'puts invalid input' do
        expect(player).to receive(:puts).with('Invalid number - (-1) must be between 0 and 5').once

        player.get
      end
    end

    context 'when input is "ab", "hello world", "100", then "5"' do
      before do
        allow(player).to receive(:gets).and_return('ab', 'hello world', '100', '5')
      end
      it 'puts invalid twice' do
        expect(player).to receive(:puts).with('Invalid input - must be a number between 0 and 5').twice
        expect(player).to receive(:puts).with('Invalid number - (100) must be between 0 and 5').once

        player.get
      end
    end
  end
end
