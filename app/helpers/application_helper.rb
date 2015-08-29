module ApplicationHelper

  def option_values
    [
      ["சொல் வளம் (விரைவில்)", "vocabulary", "#", true],
      ["இலக்கணம் (விரைவில்)", "grammar", "#", true],
      [I18n.t("question_sets.index.title"), "question_sets", question_sets_path, admin_or_superadmin?],
    ]
  end
  
  def sidebar_options
    options = [["விதிமுறைகள்", "rules", "#", true]]
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
    @selected_tab.to_s == option[1] ? "active list-group-item" : "list-group-item"
  end

  

end
