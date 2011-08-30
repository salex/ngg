module GroupsHelper
  def group_tees
    opt = "<option value=\"\">Select Tee</option>"
    for course in @current_group.courses
      opt << "<optgroup label=\"#{course.name}\">"
      for tee in course.tees
        opt << "<option value=\"#{tee.id}\">#{tee.tee}-#{tee.color}</option>"
      end
      opt << "</optgroup>"
    end
    return opt.html_safe
  end
end
