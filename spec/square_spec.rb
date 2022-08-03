require 'square'

RSpec.describe Square do
  describe '#initialize' do
    context 'sets the background color' do
      it 'green when rank and file are the same parity' do
        square_dark = described_class.new(file: 1, rank: 1)
        background_color = square_dark.background_color
        expect(background_color).to eq('green')
      end

      it 'light yellow when rank and file are the opposite parity' do
        square_light = described_class.new(file: 5, rank: 2)
        background_color = square_light.background_color
        expect(background_color).to eq('light_yellow')
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
    it 'returns the upper (and lower) third of the square' do
      square = described_class.new(file: 5, rank: 2)
      background_color = square.background_color
      result = square.upper_lower_third
      expect(result).to eq("     ".send("on_#{background_color}".to_sym))
    end
  end

  describe '#middle_third' do
    let(:piece) { double('piece', symbol: 'S') }
    subject(:square_piece) { described_class.new(file: 5, rank: 2, piece: piece)}
    subject(:square_empty) { described_class.new(file: 5, rank: 2, piece: nil)}
    it 'returns the part of the square with the piece' do
      background_color = square_piece.background_color
      result = square_piece.middle_third
      expected = ("  S  ").send("on_#{background_color}".to_sym)
      expect(result).to eq(expected)
    end

    it 'returns no piece if the square is empty' do
      background_color = square_empty.background_color
      result = square_empty.middle_third
      expected = ("     ").send("on_#{background_color}".to_sym)
      expect(result).to eq(expected)
    end
  end
end
