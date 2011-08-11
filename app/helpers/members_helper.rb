module MembersHelper
  def status_select(f)
    f.select :status, ["Active","Inactive","Hidden","Deleted"]
  end
  def role_select(f)
    if can? :invite, Member
      f.select :role_hash, ["Member","Admin","Coordinator","Scorer","Upload","Guest"], {},{:multiple => true}
    else
      f.select :roles, ["Member","Scorer","Upload"]
    end
  end
  
end
