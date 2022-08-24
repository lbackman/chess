# frozen_string_literal: true

# spec/chess_spec.rb

require 'chess'

RSpec.describe Chess do
  describe '#main_menu' do
    subject(:chess) { described_class.new }

    before do
      allow(chess).to receive(:system).with('clear')
      allow(chess).to receive(:puts)
      allow(chess).to receive(:game_setup)
      allow(chess).to receive(:load_saved_game)
      allow(chess).to receive(:exit)
      allow(chess).to receive(:game_over_prompt)
    end

    context 'when pressing [n]' do
      before { allow($stdin).to receive(:getch).and_return('n') }

      it 'sets up new game' do
        expect(chess).to receive(:game_setup)
        chess.main_menu
      end
    end

    context 'when pressing [l]' do
      before { allow($stdin).to receive(:getch).and_return('l') }

      it 'loads a game' do
        expect(chess).to receive(:load_saved_game)
        chess.main_menu
      end
    end

    context 'when pressing [q]' do
      before { allow($stdin).to receive(:getch).and_return('q') }

      it 'quits' do
        expect(chess).to receive(:exit)
        chess.main_menu
      end
    end

    context 'when pressing any other key' do
      before { allow($stdin).to receive(:getch).and_return('5') }

      it 'returns to main menu' do
        expect(chess).to receive(:main_menu)
        chess.main_menu
      end
    end
  end
end
