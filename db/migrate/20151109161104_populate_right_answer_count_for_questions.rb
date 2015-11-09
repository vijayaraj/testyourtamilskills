class PopulateRightAnswerCountForQuestions < ActiveRecord::Migration
  def change
    right_answers = {}
    UserQuestionSet.answered.each do |uqs|
      uqs.answers.each do |question_id, answer|
        q = Question.find(question_id)
        if q.answer == answer
          right_answers[question_id] = right_answers[question_id].to_i + 1
        end
      end
    end
    right_answers.each do |question_id, right_answer_count|
      q = Question.find(question_id.to_i)
      q.update_attributes(right_answer_count: right_answer_count)
    end
  end
end
