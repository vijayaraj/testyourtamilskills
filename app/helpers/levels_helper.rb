module LevelsHelper
  def play_status_icon(status)
    return level_icons[:not_started] unless status
    level_icons[UserQuestionSet::STATUS[status]]
  end

  def play_status(status)
    status ? UserQuestionSet::STATUS[status] : :not_started
  end

  def level_allowed?
    @level.previous_level ? @level.previous_level_completed? : true
  end

  def fetch_action(status)
    case status.to_i
    when 0
      I18n.t('actions.play')
    when UserQuestionSet::STATUS.invert[:in_progress]
      I18n.t('actions.resume')
    when UserQuestionSet::STATUS.invert[:completed]
      I18n.t('actions.view')
    else
      'Error'
    end
  end

  def level_icons
    {
      in_progress: 'fa-hourglass-half',
      completed: 'fa-check',
      failure: 'fa-close',
      not_started: 'fa-hourglass-1'
    }
  end
end
