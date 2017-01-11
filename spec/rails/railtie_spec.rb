# frozen_string_literal: true
RSpec.describe Epilog::Rails::Railtie do
  it 'uses the default Rails logger' do
    expect(Rails.configuration.epilog.logger).to eq(Rails.logger)
  end
end
