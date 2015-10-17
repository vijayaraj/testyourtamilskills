module QuestionsHelper
  def choice_placeholder(i)
    return %(#{t('questions.new.choice')} #{i}) unless i.eql?(5)
    %(#{t('questions.new.choice')} #{i} (#{t('questions.new.optional')}))
  end
end
