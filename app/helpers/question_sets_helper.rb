module QuestionSetsHelper
  
  def category_list
    Category.all.collect{ |category| [category.name, category.id] }  
  end

  def level_list
    Level.all.collect{ |level| [level.name, level.id] }  
  end

  def user_answer(user_question_set, question)
    user_question_set.answers[question.id.to_s] if user_question_set.answers
  end

end
