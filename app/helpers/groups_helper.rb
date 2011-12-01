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
  
  def team_opt(memb="")
    t = %w(Indiv 1 2 3 4 5 6 7 8)
    opt = "<option value=\"\"></option>"
    t.each do |i|
      sel = memb == i ? "selected=\"selected\"" : ""
      opt << "<option #{sel} value=\"#{i}\">#{i}</option>"
    end
    return opt.html_safe
  end
end
