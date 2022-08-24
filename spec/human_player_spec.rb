# frozen_string_literal: true

# spec/human_player_spec.rb

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

  describe '#handle_input' do
    before do
      allow(game).to receive(:display)
      allow(game).to receive(:save_game)
    end

    context 'when the user presses the up arrow key' do
      it 'sends :change_rank(1) to board' do
        allow($stdin).to receive(:getch).and_return('[', 'A')

        expect(board).to receive(:change_rank).with(1)
        human.handle_input(game, board)
      end
    end

    context 'when the user presses the left arrow key' do
      it 'sends :change_file(-1) to board' do
        allow($stdin).to receive(:getch).and_return('[', 'D')

        expect(board).to receive(:change_file).with(-1)
        human.handle_input(game, board)
      end
    end

    context 'when the user presses S' do
      it 'saves game' do
        allow($stdin).to receive(:getch).and_return('s')

        expect(game).to receive(:save_game)
        human.handle_input(game, board)
      end
    end

    context 'when the user presses Q' do
      it 'quits game' do
        allow($stdin).to receive(:getch).and_return('q')

        expect(human).to receive(:exit)
        human.handle_input(game, board)
      end
    end

    context 'when the user presses Enter' do
      it 'returns true' do
        allow($stdin).to receive(:getch).and_return("\r")

        expect(human.handle_input(game, board)).to eq(true)
      end
    end
  end
end
