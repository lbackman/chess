require 'square'

RSpec.describe Square do
  describe '#initialize' do
    context 'sets the background color' do
      it 'darker when rank and file are the same parity, and vice versa' do
        square_dark = described_class.new(file: 1, rank: 1)
        square_light = described_class.new(file: 5, rank: 2)
        background_dark = square_dark.background_color
        background_light = square_light.background_color
        expect(background_dark).to be < (background_light)
      end
    end
  end

  describe '#to_s' do
    it 'represents the square with algebraic notation' do
      square = Square.new(file: 4, rank: 1)
      string = "#{square}"
      expect(string).to eq('d1')
    end
  end

  describe '#upper_lower_third' do
    subject(:square) { described_class.new(file: 5, rank: 2) }
    before { allow(square).to receive(:choose_color).and_return('255') }
    it 'returns the upper (and lower) third of the square' do
      background_color = square.background_color
      result = square.upper_lower_third
      expect(result).to eq("\u001b[48;5;255m     \u001b[0m")
    end
  end

  describe '#middle_third' do
    let(:piece) { double('piece', symbol: 'S') }
    subject(:square_piece) { described_class.new(file: 5, rank: 2, piece: piece)}
    subject(:square_empty) { described_class.new(file: 5, rank: 2, piece: nil)}
    before { allow(square_piece).to receive(:choose_color).and_return('255') }
      
    it 'returns the part of the square with the piece' do
      background_color = square_piece.background_color
      result = square_piece.middle_third
      expected = ("\u001b[48;5;255m  S  \u001b[0m")
      expect(result).to eq(expected)
    end

    before { allow(square_empty).to receive(:choose_color).and_return('255') }
    it 'returns no piece if the square is empty' do
      background_color = square_empty.background_color
      result = square_empty.middle_third
      expected = "\u001b[48;5;255m     \u001b[0m"
      expect(result).to eq(expected)
    end
  end
end
