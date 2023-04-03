class SessionsController < ApplicationController
    # before_action :administration
    # skip_before_action :administration, only: [:create, :destroy, :in]
    # skip_before_action :authorize, only:[:create, :in, :out]

    skip_before_action :authorized, only: [:create]
    
    # POST /login
    # def create
    #     user = User.find_by(username: params[:username])
    #     if user&.authenticate(params[:password])
    #         session[:user_id] = user.id
    #         render json: user, status: :created
    #     else
    #         render json: { errors: ["Invalid username or password"] }, status: :unauthorized
    #     end
    # end

    def create
        @user = User.find_by(username: user_login_params[:username])
        #User#authenticate comes from BCrypt
        if @user && @user.authenticate(user_login_params[:password])
          # encode token comes from ApplicationController
          token = encode_token({ user_id: @user.id })
          render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
        else
          render json: { message: 'Invalid username or password' }, status: :unauthorized
        end
      end

    # DELETE /logout
    def destroy
        session.delete :user_id
        head :no_content
    end

    # POST /adminin
    def in
        admin = Admin.find_by(admin_name: params[:admin_name])
        if admin&.authenticate(params[:password])
            session[:admin_id] = admin.id
            render json: admin, status: :created
        else
            render json: { errors: ["Invalid admin_name or password"] }, status: :unauthorized
        end
    end

    #DELETE /adminout
    def out
        session.delete :admin_id
        head :no_content
    end

    private

  def user_login_params
    # params { user: {username: 'Chandler Bing', password: 'hi' } }
    params.require(:user).permit(:username, :password)
  end

    
end
