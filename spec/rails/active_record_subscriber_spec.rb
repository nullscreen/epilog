# frozen_string_literal: true

RSpec.describe Epilog::Rails::ActiveRecordSubscriber do
  it 'logs a select query' do
    User.find_by(id: 1)
    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'User Load',
      sql: 'SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1',
      binds: [{ type: :integer, name: 'id', value: 1 }],
      metrics: {
        query_runtime: be_between(0, 20)
      }
    )
  end
end
