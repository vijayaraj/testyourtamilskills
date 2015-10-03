module QuestionsHelper
  def choice_placeholder(i)
    i.eql?(5) ? %(#{t("questions.new.choice")} #{i} (#{t("questions.new.optional")})) : 
      %(#{t("questions.new.choice")} #{i})
  end
end