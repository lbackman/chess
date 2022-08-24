# frozen_string_literal: true

# spec/game_spec.rb

require 'game'

RSpec.describe Game do
  describe '#play_chess' do
    subject(:game) { described_class.new(players: [player1, player2]) }
    let(:player1) { double('player', color: :white) }
    let(:player2) { double('player', color: :black) }
    let(:board) { double('board') }

    before do
      allow(game).to receive(:system).with('clear')
      allow(game).to receive(:game_over?).and_return(false, false, true)
      allow(game).to receive(:set_up_and_play)
      allow(game).to receive(:end_of_game)
    end

    it 'starts game loop' do
      expect(game).to receive(:set_up_and_play).exactly(3).times
      game.play_chess
    end

    it 'changes player twice' do
      expect(game).to receive(:change_player!).twice
      game.play_chess
    end

    it 'displays game over message' do
      expect(game).to receive(:end_of_game).once
      game.play_chess
    end
  end

  describe '#display' do
    subject(:game) { described_class.new(players: %w[player1 player2]) }
    let(:board) { double('board') }

    it 'shows the current state of the game' do
      allow_any_instance_of(Game).to receive(:set_up_board).and_return(board)
      expect(board).to receive(:print_board)
      expect(game).to receive(:puts).exactly(3).times
      expect(game).to receive(:print).once
      game.display
    end
  end

  describe '#set_up_and_play' do
    subject(:game) { described_class.new(players: [player1, player2]) }
    let(:player1) { double('player', color: :white) }
    let(:player2) { double('player', color: :black) }
    let(:board) { double('board') }

    it 'plays a round' do
      expect(game).to receive(:play_round)
      game.set_up_and_play
    end
  end

  describe '#move_piece' do
    subject(:new_game) { described_class.new(players: %w[p1 p2]) }
    let(:board) { double('board') }
    let(:start) { double('square') }
    let(:destination) { double('square') }
    before { allow(start).to receive(:to_a) }
    before { allow(destination).to receive(:to_a) }

    it 'sends message to Board' do
      allow_any_instance_of(Game).to receive(:set_up_board).and_return(board)
      expect(board).to receive(:move_piece).with(start.to_a, destination.to_a)
      new_game.move_piece(start, destination)
    end
  end

  describe '#change_player!' do
    subject(:game) { described_class.new(players: [player1, player2]) }
    let(:player1) { double('player') }
    let(:player2) { double('player') }
    context 'when the current player is player_1' do
      it 'changes to p2' do
        expect { game.change_player! }.to change { game.current_player }.to(player2)
      end
    end

    context 'when the current player is player_2' do
      before { game.change_player! }

      it 'changes to p1' do
        expect { game.change_player! }.to change { game.current_player }.to(player1)
      end
    end
  end

  describe '#game_over?' do
    subject(:game) { described_class.new(players: %w[p1 p2]) }

    it 'returns false when neither checkmate nor stalemate' do
      allow(game).to receive(:checkmate?).and_return(false)
      allow(game).to receive(:stalemate?).and_return(false)
      expect(game.game_over?).to be(false)
    end

    it 'returns true when checkmate' do
      allow(game).to receive(:checkmate?).and_return(true)
      allow(game).to receive(:stalemate?).and_return(false)
      expect(game.game_over?).to be(true)
    end

    it 'returns true when stalemate' do
      allow(game).to receive(:checkmate?).and_return(false)
      allow(game).to receive(:stalemate?).and_return(true)
      expect(game.game_over?).to be(true)
    end
  end
end
