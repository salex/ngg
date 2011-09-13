module GroupsHelper
  def group_tees(tee_id=nil)
    opt = "<option value=\"\">Select Tee</option>"
    for course in @current_group.courses
      opt << "<optgroup label=\"#{course.name}\">"
      for tee in course.tees
        sel = (!tee_id.nil? && (tee.id == tee_id) ? "selected=\"selected\"" : "")
        opt << "<option value=\"#{tee.id}\" #{sel}>#{tee.tee}-#{tee.color}</option>"
      end
      opt << "</optgroup>"
    end
    return opt.html_safe
  end
end
