class SessionsController < ApplicationController
  skip_before_action :login_required
  before_action :forbidden_loggedin_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      log_in user
      session_params[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to root_url, notice: 'ログインしました'
    else
      flash.now.alert = 'メールアドレスまたはパスワードが間違っています'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path, notice: 'ログアウトしました'
  end

  private
    def forbidden_loggedin_user
      redirect_to memos_path if logged_in?
    end

    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end
end
