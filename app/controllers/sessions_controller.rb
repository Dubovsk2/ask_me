class SessionsController < ApplicationController
  def new
  end

  def create
    user_params = params.require(:session)
    user = User.find_by(email: user_params[:email])&.authenticate(user_params[:password])
    if user.present?
      session[:user_id] = user.id
      session[:nickname] = user.nickname
      redirect_to root_path, notice: 'Successful login.'
    else
      flash[:alert] = 'Wrong login details.'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:nickname)
    redirect_to root_path
  end
end
