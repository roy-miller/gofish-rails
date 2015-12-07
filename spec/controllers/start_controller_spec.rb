require 'rails_helper'

RSpec.describe StartController, type: :controller do
  # QUESTION: use a factory, or keep it real?
  # let!(:existing_user) { User.create(name: 'ExistingUser') }
  #
  # before do
  #   controller.send(:reset_match_maker)
  # end
  #
  # describe "POST #wait" do
  #   it 'creates new user if user does not exist' do
  #     expect {
  #       post :wait, { number_of_opponents: 1, user_name: 'NewUser' }
  #     }.to change(User, :count).by(1)
  #     # expect(User).to receive(:find_or_create_by).with(name: 'NewUser').exactly(1).times
  #   end
  #
  #   it 'finds existing user' do
  #     expect {
  #       post :wait, { number_of_opponents: 1, user_name: 'ExistingUser' }
  #     }.not_to change(User, :count)
  #   end
  #
  #   it 'sets number of players for view' do
  #     post :wait, {number_of_opponents: 1, user_name: 'ExistingUser'}
  #     expect(assigns(:number_of_players)).to eq 2
  #   end
  #
  #   it 'sets user for view when user waiting for match' do
  #     post :wait, {number_of_opponents: 1, user_name: 'ExistingUser'}
  #     expect(assigns(:user)).to eq existing_user
  #   end
  #
  #   it 'renders wait view if no match started' do
  #     post :wait, {number_of_opponents: 1, user_name: 'ExistingUser'}
  #     expect(response).to render_template('start/wait')
  #   end
  # end
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
