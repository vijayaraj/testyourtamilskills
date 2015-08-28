module LevelsHelper

  def play_status(status)
    status ? level_icons[UserQuestionSet::STATUS[status]] : level_icons[:not_started]
  end

  def level_allowed?
    @level.previous_level ? @level.previous_level_completed? : true
  end

  def fetch_action(status)
    case status.to_i
    when 0
      I18n.t("actions.play")
    when UserQuestionSet::STATUS.invert[:in_progress]
      I18n.t("actions.resume")
    when UserQuestionSet::STATUS.invert[:success]
      I18n.t("actions.view")
    else
      "Error"
    end    
  end

  def level_icons
    {
      :in_progress => "fa-hourglass-half",
      :success => "fa-check",
      :failure => "fa-close",
      :not_started => "fa-hourglass-1"
    }
  end
end
