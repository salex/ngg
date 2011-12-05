module MembersHelper
  def status_select(f)
    f.select :status, ["Active","Inactive","Hidden","Deleted"]
  end
  def status_options
    return ["Active","Inactive","Hidden","Deleted"]
  end
  
  def memb_tee_options(member,course_id)
    c = Course.find(course_id)
    t = Tee.get_tees(c.id)
    teeopt = ""
    for tee in t 
      quota, limited = member.get_member_quota(tee.id)
      limit = @current_group.uses_round_limit ? @current_group.round_limit : 36
      limit = limited ? @current_group.new_member_limit : limit
      star = limited ? "*" : ""
      sel = ""
      if member.tee == tee.tee  
        sel =  'selected="selected"'
        @limited = limited
        @quota = quota
      end
      #teeopt += '<option value="'+quota.to_s+star+'_'+tee.id.to_s+'" ' + sel + '>'+tee.color+":"+quota.to_s+star+'</option>'
      teeopt += '<option value="'+ tee.id.to_s + '"' + sel+ ' title="'+quota.to_s+":"+star+":"+limit.to_s+'">'+tee.color+":"+quota.to_s+star+'</option>'
    end
    return teeopt.html_safe
  end
end
