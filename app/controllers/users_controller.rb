class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.where(type: nil) # TODO why does where.not(type: 'RobotUser') fail?
  end

  # GET /users/1
  # GET /users/1.json
  def show
    user_wins = @user.matches.where(status: MatchStatus::FINISHED, winner: @user)
    user_losses = @user.matches.where(status: MatchStatus::FINISHED).where.not(winner: @user)
    @wins = user_wins.count
    @losses = user_losses.count
    #SELECT COUNT(*) FROM matches INNER JOIN matches_users ON matches.id = matches_users.match_id WHERE matches_users.user_id = $1 AND matches.status = $2 AND matches.winner_id = 69
    #@top_ten_match_winners = User.select("*, (#{@user.matches.where(status: MatchStatus::FINISHED, winner: @user).to_sql}) as wins").order('wins DESC').limit(10)
    ranked_users = User.select("*, (SELECT COUNT(*) FROM matches INNER JOIN matches_users ON matches.id = matches_users.match_id WHERE matches_users.user_id = #{@user.id} AND matches.status = '#{MatchStatus::FINISHED}' AND matches.winner_id = #{@user.id}) as wins").order('wins DESC')
    @rank = user_rank(@user, ranked_users)
    @top_ten_match_winners = ranked_users.limit(10)
  end

  def user_rank(user, ranked_users)
    ranked_users.index(user) + 1
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name)
    end
end
