# frozen_string_literal: true

RSpec.describe Epilog do
  it 'has a cannonical version number' do
    expect(Gem::Version.new(described_class::VERSION).to_s)
      .to eq described_class::VERSION
  end
end
