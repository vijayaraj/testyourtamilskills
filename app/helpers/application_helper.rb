module ApplicationHelper
  def option_values
    [
      [I18n.t('question_sets.index.title'), 'question_sets',
       question_sets_path, true]
    ]
  end

  def sidebar_options
    options = [[I18n.t('sidebar.rules'), 'rules', root_path, true]]
    Category.all.order(:id).map do |c|
      options << [c.name, %(category_#{c.id}), category_path(c.id), true]
    end
    option_values.each { |option| options << option }
    options
  end

  def sidebar_list
    categories = sidebar_options.map do |option|
      if option[3]
        content_tag(:a, option[0], href: option[2],
                    :class => category_class(option)).html_safe
      end
    end
    categories.compact
  end

  def category_class(option)
    return 'active list-group-item' if @selected_tab.to_s.eql?(option[1])
    'list-group-item'
  end

  def ta_hello_text(text)
    current_user ? %(#{text}, #{current_user.name}) : %(#{text}.)
  end

  def en_hello_text(text)
    current_user ? %(#{text} #{current_user.name},) : %(#{text} there,)
  end
end
