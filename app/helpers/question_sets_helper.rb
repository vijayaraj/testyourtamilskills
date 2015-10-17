module QuestionSetsHelper
  def category_list
    Category.all.collect { |category| [category.name, category.id] }
  end

  def category_link
    category = @question_set.category
    link_to(category.name, category_path(category.id))
  end

  def level_list(category)
    category.levels.all.collect { |level| [level.name, level.id] }
  end

  def level_link
    level = @question_set.level
    link_to(level.name, level_path(level.id))
  end

  def user_answer(user_question_set, question)
    user_question_set.answers[question.id.to_s] if user_question_set.answers
  end

  def questions_count(question_set)
    %(#{question_set.questions.count} / 15)
  end

  def answer_icon(question, answer)
    (question.answer.eql?(answer)) ? 'check' : 'times'
  end
end
