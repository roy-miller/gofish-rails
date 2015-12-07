require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "GET #index" do
    it 'renders the welcome page view' do
      get :index
      expect(response).to render_template('welcome/index')
    end
  end
end
