require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it 'renders the welcome page view' do
    get :index
    expect(response).to render_template('welcome/index')
  end
end
