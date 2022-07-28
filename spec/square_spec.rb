require 'square'

RSpec.describe Square do
  describe '#initialize' do
    context 'sets the background color' do
      it 'dark when rank and file are the same parity' do
        square_dark = described_class.new(file: 1, rank: 1)
        background_color = square_dark.background_color
        expect(background_color).to eq('dark')
      end

      it 'light when rank and file are the opposite parity' do
        square_light = described_class.new(file: 5, rank: 2)
        background_color = square_light.background_color
        expect(background_color).to eq('light')
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
end
