# frozen_string_literal: true

RSpec.describe Epilog::Rails::Railtie do
  it 'overrides the default Rails logger' do
    if Rails.logger.respond_to?(:broadcasts)
      expect(Rails.logger.broadcasts).to include(MOCK_LOGGER)
    else
      expect(Rails.logger).to eq(MOCK_LOGGER)
    end
  end
end
