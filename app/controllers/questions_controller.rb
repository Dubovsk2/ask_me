class QuestionsController < ApplicationController
  before_action :ensure_current_user, only: [:update, :destroy, :edit, :hide]
  before_action :set_question_for_authorized_user, only: [:update, :destroy, :edit, :hide]


  def create
    author = current_user.present? ? current_user.id : nil
    question_params = params.require(:question).permit(:body, :user_id)
    @question = Question.new(question_params)
    @question.author_id = author
    @question.save
    redirect_to user_path(@question.user), notice: 'New question was created.'
  end

  def update
    question_params = params.require(:question).permit(:body, :answer)
    @question.update(question_params)
    redirect_to user_path(@question.user), notice: 'Your question was updated.'
  end

  def destroy
    @user = @question.user
    @question.destroy
    redirect_to user_path(@user), notice: 'Your question was deleted.'
  end

  def show
    @question = Question.find(params[:id])
    if @question.hidden == true && @question.user != current_user
      @question = nil
    end
  end

  def index
    @users = User.last(5).shuffle.sample(3)
    @questions = Question.order(created_at: :desc).reject {|question| question.hidden == true }
  end

  def new
    @user = User.find(params[:user_id])
    @question = Question.new(user: @user)
  end

  def edit
  end

  def hide
    @question.hidden = !@question.hidden
    @question.save
    redirect_to user_path(@question.user)
  end

  private

  def ensure_current_user
    redirect_with_alert unless current_user.present?
  end

  def set_question_for_authorized_user
    @question = current_user.questions.find(params[:id])
  end
end
