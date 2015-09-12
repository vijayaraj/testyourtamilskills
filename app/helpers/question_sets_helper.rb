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

  def questions_count(question_set)
    %(#{question_set.questions.count} / 15)
  end

  def answer_icon(question, answer)
    (question.answer.eql?(answer)) ? "check" : "times"
  end

  def answer(answers, index, page, per_page = 5)
    answers ||= {}
    page ||= 1
    key = ((page.to_i - 1) * per_page) + (index + 1)

    answers[key.to_s] || I18n.t("questions.not_answered")
  end

end
