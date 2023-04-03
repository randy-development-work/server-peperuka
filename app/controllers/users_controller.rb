class UsersController < ApplicationController
  skip_before_action :authorized, only:[:create]

  # GET /users
  # def index
  #   @users = User.all

  #   render json: @users
  # end

  # GET /me
  # def show
  #   user = User.find_by(id: session[:user_id])
  #   render json: user, status: :created
  # end

  # auto-login /GET /me
  def show
    render json: { user: UserSerializer.new(current_user) }, status: :accepted
  end

 # POST /sign up
 def create
  @user = User.create(user_params)
  if @user.valid?
    render json: { user: UserSerializer.new(@user) }, status: :created
  else
    render json: { error: 'failed to create user' }, status: :unprocessable_entity
  end
end

  # PATCH/PUT /users/1
  # def update
  #   if @user.update(user_params)
  #     render json: @user
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /users/1
  # def destroy
  #   @user.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
