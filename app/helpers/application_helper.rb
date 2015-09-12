module ApplicationHelper

  MUTED = ["vocabulary", "grammar"]
  
  def option_values
    [
      [I18n.t("sidebar.vocabulary"), "vocabulary", "#", true],
      [I18n.t("sidebar.grammar"), "grammar", "#", true],
      [I18n.t("question_sets.index.title"), "question_sets", question_sets_path, true],
    ]
  end
  
  def sidebar_options
    options = [[I18n.t("sidebar.rules"), "rules", root_path, true]]
    Category.all.map { |c| options << [c.name, "category_#{c.id}", category_path(c.id), true] }
    option_values.each do |o|
      options << o
    end
    options
  end
  
  def sidebar_list
    categories = sidebar_options.map do |option| 
      if option[3]
        content_tag(:a, option[0], :href => option[2], :class => category_class(option)).html_safe
      end
    end
    categories.compact
  end

  def category_class(option)
    muted = MUTED.include?(option[1]) ? "muted" : ""
    @selected_tab.to_s == option[1] ? "active list-group-item" : "list-group-item #{muted}"
  end

end
