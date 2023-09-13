class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  
  def create
    @user = User.new(set_params)
    if @user.save == true
      session[:user_id] = @user.id
      session[:nickname] = user.nickname
      redirect_to questions_path(@question), notice: 'The account was created successfully.'
    else
      flash[:alert] = 'Wrong user credentials.'
      render :new
    end
  end

  def new
    @user = User.new
  end

  def edit 
  end

  def show
    @questions = current_user == @user ? @user.questions.order("created_at DESC") : @user.questions.order("created_at DESC").reject { |question| question.hidden == true }
    @question = Question.new(user: @user)
  end

  def update
    if @user.update(set_params)
      redirect_to user_path(@user)
    else
      flash[:alert] = 'Wrong user credentials.'
      render :edit
    end
  end

  def destroy
    @user.destroy
    session[:user_id].destroy
    session.delete(:nickname)
    redirect_to questions_path(@question)
  end

  private

  def set_params
    params.require(:user).permit(:name, :nickname, :email, :password, :password_confirmation, :color)
  end

  def set_user
    @user = User.find_by(nickname: params[:nickname])
  end

  def authorize_user
    redirect_with_alert unless current_user == @user
  end
end
