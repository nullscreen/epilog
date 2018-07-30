# frozen_string_literal: true

# rubocop:disable BlockLength
RSpec.describe Epilog::Filter::Blacklist do
  it 'hashes blacklisted keys' do
    filtered = described_class.new.call(good: 'hooray', password: 'secret')
    expect(filtered).to eq(
      good: 'hooray',
      password: '[filtered String]'
    )
  end

  it 'filters nested hashes' do
    filtered = described_class.new.call(bad: { password: 'foo' })
    expect(filtered).to eq(
      bad: {
        password: '[filtered String]'
      }
    )
  end

  it 'filters blacklisted hashes' do
    filtered = described_class.new.call(password: { foo: 'bar' })
    expect(filtered).to eq(password: '[filtered Hash]')
  end

  it 'matches any case' do
    filtered = described_class.new.call(PASSword: 'mypass')
    expect(filtered).to eq(
      PASSword: '[filtered String]'
    )
  end

  it 'filters an array of hashes' do
    filtered = described_class.new.call([{ password: 'pass' }, { pw: 'other' }])
    expect(filtered).to eq(
      [
        { password: '[filtered String]' },
        { pw: '[filtered String]' }
      ]
    )
  end
end
# rubocop:enable BlockLength
