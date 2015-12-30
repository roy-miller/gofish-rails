require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  # let!(:existing_user) { create(:real_user, name: 'ExistingUser') }
  # let!(:waiting_user) { create(:real_user, name: 'WaitingUser') }
  #
  # before do
  #   controller.send(:reset_match_maker)
  #   sign_in existing_user
  # end
  #
  # it 'gets perspective for user' do
  #   expect(:get => "/matches/1/users/2").to route_to(
  #     :controller => "matches",
  #     :action => "show",
  #     :match_id => "1",
  #     :user_id => "2"
  #   )
  # end
  #
  # describe "POST #new" do
  #   it 'sets number of players for view' do
  #     post :new, {number_of_opponents: 1, user_name: 'ExistingUser'}
  #     expect(assigns(:number_of_players)).to eq 2
  #   end
  #
  #   it 'sets user for view' do
  #     post :new, {number_of_opponents: 1, user_name: 'ExistingUser'}
  #     expect(assigns(:user)).to eq existing_user
  #   end
  #
  #   it 'renders wait view if no match started' do
  #     post :new, {number_of_opponents: 1, user_name: 'ExistingUser'}
  #     expect(response).to render_template('start/wait')
  #   end
  #
  #   # TODO why do I get a circular ref error for Game?
  #   # it 'redirects to match view if match started' do
  #   #   controller.send(:match_maker_timeout=, 0.25)
  #   #   controller.send(:match_maker).pending_users[2] = [waiting_user]
  #   #   post :new, {number_of_opponents: 1, user_name: 'ExistingUser'}
  #   #   #expect(response).to redirect_to("/matches/#{match.id}/users/#{existing_user.id}")
  #   #   expect(response.location).to match(/matches\/\d+\/users\/#{existing_user.id}/)
  #   #   expect(controller.current_user).to eq existing_user
  #   # end
  #
  #   context 'json' do
  #     it 'returns json to waiting user if requested format is json' do
  #       post :new, {number_of_opponents: 1, user_name: 'ExistingUser', format: :json}
  #       parsed_body = JSON.parse(response.body)
  #       expect(response). to have_http_status(200)
  #       expect(parsed_body['message']).to match(/waiting for 2 players/i)
  #     end
  #   end
  # end
  #
  # # describe "POST #update" do
  # #   it 'updates player hands correctly after a player asks for cards' do
  # #     post :update, {match_id: 1, requestor_id: 1, requested_id: 1, card_rank: 'K'}
  # #
  # #   end
  # # end
  #
  # # describe "POST #simulate_start" do
  # #   it 'returns json for user' do
  # #     post :simulate_start, {format: :json}
  # #     parsed_body = JSON.parse(response.body)
  # #     expect(parsed_body['status']).to match(/started/i)
  # #   end
  # # end
end

# RSpec.describe UsersController, type: :controller do
#
#   # This should return the minimal set of attributes required to create a valid
#   # User. As you add validations to User, be sure to
#   # adjust the attributes here as well.
#   let(:valid_attributes) {
#     skip("Add a hash of attributes valid for your model")
#   }
#
#   let(:invalid_attributes) {
#     skip("Add a hash of attributes invalid for your model")
#   }
#
#   # This should return the minimal set of values that should be in the session
#   # in order to pass any filters (e.g. authentication) defined in
#   # UsersController. Be sure to keep this updated too.
#   let(:valid_session) { {} }
#
#   describe "GET #index" do
#     it "assigns all users as @users" do
#       user = User.create! valid_attributes
#       get :index, {}, valid_session
#       expect(assigns(:users)).to eq([user])
#     end
#   end
#
#   describe "GET #show" do
#     it "assigns the requested user as @user" do
#       user = User.create! valid_attributes
#       get :show, {:id => user.to_param}, valid_session
#       expect(assigns(:user)).to eq(user)
#     end
#   end
#
#   describe "GET #new" do
#     it "assigns a new user as @user" do
#       get :new, {}, valid_session
#       expect(assigns(:user)).to be_a_new(User)
#     end
#   end
#
#   describe "GET #edit" do
#     it "assigns the requested user as @user" do
#       user = User.create! valid_attributes
#       get :edit, {:id => user.to_param}, valid_session
#       expect(assigns(:user)).to eq(user)
#     end
#   end
#
#   describe "POST #create" do
#     context "with valid params" do
#       it "creates a new User" do
#         expect {
#           post :create, {:user => valid_attributes}, valid_session
#         }.to change(User, :count).by(1)
#       end
#
#       it "assigns a newly created user as @user" do
#         post :create, {:user => valid_attributes}, valid_session
#         expect(assigns(:user)).to be_a(User)
#         expect(assigns(:user)).to be_persisted
#       end
#
#       it "redirects to the created user" do
#         post :create, {:user => valid_attributes}, valid_session
#         expect(response).to redirect_to(User.last)
#       end
#     end
#
#     context "with invalid params" do
#       it "assigns a newly created but unsaved user as @user" do
#         post :create, {:user => invalid_attributes}, valid_session
#         expect(assigns(:user)).to be_a_new(User)
#       end
#
#       it "re-renders the 'new' template" do
#         post :create, {:user => invalid_attributes}, valid_session
#         expect(response).to render_template("new")
#       end
#     end
#   end
#
#   describe "PUT #update" do
#     context "with valid params" do
#       let(:new_attributes) {
#         skip("Add a hash of attributes valid for your model")
#       }
#
#       it "updates the requested user" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => new_attributes}, valid_session
#         user.reload
#         skip("Add assertions for updated state")
#       end
#
#       it "assigns the requested user as @user" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
#         expect(assigns(:user)).to eq(user)
#       end
#
#       it "redirects to the user" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
#         expect(response).to redirect_to(user)
#       end
#     end
#
#     context "with invalid params" do
#       it "assigns the user as @user" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
#         expect(assigns(:user)).to eq(user)
#       end
#
#       it "re-renders the 'edit' template" do
#         user = User.create! valid_attributes
#         put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
#         expect(response).to render_template("edit")
#       end
#     end
#   end
#
#   describe "DELETE #destroy" do
#     it "destroys the requested user" do
#       user = User.create! valid_attributes
#       expect {
#         delete :destroy, {:id => user.to_param}, valid_session
#       }.to change(User, :count).by(-1)
#     end
#
#     it "redirects to the users list" do
#       user = User.create! valid_attributes
#       delete :destroy, {:id => user.to_param}, valid_session
#       expect(response).to redirect_to(users_url)
#     end
#   end
#
# end
