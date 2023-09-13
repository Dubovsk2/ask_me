module UsersHelper
  def user_questions
    Question.where(user_id == @user.id)
  end
end
