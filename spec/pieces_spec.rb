require 'pieces'

RSpec.shared_examples 'piece interface tests' do
  it { should respond_to :post_initialize }
  it { should respond_to :symbol }
  it { should respond_to :name }
  it { should respond_to :direction }
  it { should respond_to :movements }
  it { should respond_to :vectors }
  it { should respond_to :range }
  it { should respond_to :ep_vulnerable? }
  it { should respond_to :to_s }
end

RSpec.describe Pieces::Piece do
  subject(:piece) { described_class.new(color) }
  let(:color) { :white }
  include_examples 'piece interface tests'
end
