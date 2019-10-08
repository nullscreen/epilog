# frozen_string_literal: true

RSpec.describe Epilog::Filter::FilterParameters do
  it 'filters parameters from Rails filter_parameters' do
    filtered = described_class.new.call(
      ok: 'good',
      password: 'passw0rd1'
    )

    expect(filtered).to eq(
      ok: 'good',
      password: '[filtered String]'
    )
  end
end
