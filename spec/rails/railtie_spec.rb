# frozen_string_literal: true

RSpec.describe Epilog::Rails::Railtie do
  it 'overrides the default Rails logger' do
    expect(Rails.logger).to be_instance_of(Epilog::MockLogger)
  end
end
