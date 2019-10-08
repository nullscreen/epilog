# frozen_string_literal: true

# rubocop:disable BlockLength
RSpec.describe Epilog::Rails::ActionMailerSubscriber, type: :controller do
  render_views

  it 'logs rendering a template' do
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(file: 'action_view/template.html.erb')

    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'Rendered template',
      layout: nil,
      template: 'action_view/template.html.erb',
      metrics: {
        duration: be_between(0, 10)
      }
    )
  end

  it 'logs rendering a partial' do
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(file: 'action_view/template_w_partial.html.erb')

    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'Rendered partial',
      layout: nil,
      template: 'action_view/_partial.html.erb',
      metrics: {
        duration: be_between(0, 10)
      }
    )
  end

  it 'logs rendering a collection' do
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(file: 'action_view/template_w_collection.html.erb')

    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'Rendered collection',
      layout: nil,
      template: 'action_view/_collection.html.erb',
      metrics: {
        duration: be_between(0, 10)
      }
    )
  end
end
# rubocop:enable BlockLength
