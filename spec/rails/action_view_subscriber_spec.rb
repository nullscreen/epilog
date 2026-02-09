# frozen_string_literal: true

RSpec.describe Epilog::Rails::ActionViewSubscriber, type: :controller do
  render_views

  let(:lookup_context) do
    ActionView::LookupContext.new(ActionController::Base.view_paths)
  end
  let(:action_view_base) do
    Class.new(ActionView::Base) do
      def compiled_method_container
        self.class
      end
    end
  end
  let(:view) { action_view_base.new(lookup_context, {}, EmptyController.new) }

  it 'logs rendering a template' do
    view.render(template: 'action_view/template')

    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'Rendered template',
      layout: nil,
      template: 'action_view/template.html.erb',
      metrics: {
        duration: be_between(0, 40)
      }
    )
  end

  it 'logs rendering a partial' do
    view.render(template: 'action_view/template_w_partial')

    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'Rendered partial',
      layout: nil,
      template: 'action_view/_partial.html.erb',
      metrics: {
        duration: be_between(0, 40)
      }
    )
  end

  it 'logs rendering a collection' do
    view.render(template: 'action_view/template_w_collection')

    expect(Rails.logger[0][0]).to eq('DEBUG')
    expect(Rails.logger[0][3]).to match(
      message: 'Rendered collection',
      layout: nil,
      template: 'action_view/_collection.html.erb',
      metrics: {
        duration: be_between(0, 40)
      }
    )
  end
end
