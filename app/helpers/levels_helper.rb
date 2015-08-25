module LevelsHelper

  def play_status(status)
    status ? UserQuestionSet::STATUS[status] : "Yet"
  end

  def level_allowed?
    @level.previous_level ? @level.previous_level_completed? : true
  end

  def fetch_action(status)
    case status.to_i
    when 0
      "Play"
    when UserQuestionSet::STATUS.invert[:in_progress]
      "Resume"
    when UserQuestionSet::STATUS.invert[:success]
      "View"
    else
      "Error"
    end    
  end
end
