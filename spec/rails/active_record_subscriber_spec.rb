# frozen_string_literal: true

RSpec.describe Epilog::Rails::ActiveRecordSubscriber do
  it 'logs a select query' do
    query = format(
      'SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT %<limit>s',
      limit: Rails::VERSION::MAJOR >= 5 ? '?' : '1'
    )

    binds = [{ type: :integer, name: 'id', value: 1 }]
    if Rails::VERSION::MAJOR >= 5
      binds << { type: nil, name: 'LIMIT', value: 1 }
    end

    query.gsub!('  ', ' ') if Rails::VERSION::MAJOR >= 6

    User.find_by(id: 1)
    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'User Load',
      sql: query,
      binds:,
      metrics: {
        query_runtime: be_between(0, 20)
      }
    )
  end
end
