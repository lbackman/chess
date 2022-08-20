require 'human_player'

RSpec.describe HumanPlayer do
  subject(:human) { described_class.new(color: color) }
  let(:color) { :white }
  let(:game) { double('game') }
  let(:board) { double('board') }
  let(:start) { double('square') }
  let(:destination) { double('square') }
  let(:piece) { double('piece') }

  context 'when the player choose a valid square at once' do

    before do
      # allow(board).to receive(:current_square).and_return(start)
      allow(start).to receive(:piece_color).and_return(color)
      allow(piece).to receive(:available_moves).and_return(piece)
      allow(human).to receive(:handle_input).and_return(true)
      allow(human).to receive(:choose_start).and_return(start)
      allow(human).to receive(:choose_destination).and_return(destination)
    end

    describe '#get_start_square' do
      it 'returns a square' do
        result = human.get_start_square(game, board)
        expect(result).to eq(start)
      end
    end

    describe '#get_destination_square' do
      it 'returns a square' do
        result = human.get_destination_square(game, board, start)
        expect(result).to eq(destination)
      end
    end
  end

  context 'first two invalid squares, then a valid' do

    before do
      allow(board).to receive(:current_square).and_return(start)
      allow(start).to receive(:piece_color).and_return(color)

      allow(piece).to receive(:available_moves).and_return(piece)
      allow(human).to receive(:handle_input).and_return(true, true, true)
      allow(human).to receive(:choose_start).and_return(nil, nil, start)
      allow(human).to receive(:choose_destination).and_return(nil, nil, start)
    end

    describe '#get_start_square' do
      it 'loops three times' do
        expect(human).to receive(:handle_input).exactly(3).times
        expect(human).to receive(:choose_start).exactly(3).times.and_return(nil, nil, start)
        human.get_start_square(game, board)
      end
    end

    describe '#get_destination_square' do
      it 'also loops three times' do
        expect(human).to receive(:handle_input).exactly(3).times
        expect(human).to receive(:choose_destination).exactly(3).times.and_return(nil, nil, destination)
        human.get_destination_square(game, board, start)
      end
    end
  end
end
