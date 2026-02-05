# frozen_string_literal: true

RSpec.describe Epilog::Rails::Railtie do
  it 'overrides the default Rails logger' do
    if Rails.logger.respond_to?(:broadcasts)
      expect(Rails.logger.broadcasts.first).to be_instance_of(Epilog::MockLogger)
    else
      expect(Rails.logger).to be_instance_of(Epilog::MockLogger)
    end
  end
end
