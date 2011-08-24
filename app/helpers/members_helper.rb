module MembersHelper
  def status_select(f)
    f.select :status, ["Active","Inactive","Hidden","Deleted"]
  end
  def status_options
    return ["Active","Inactive","Hidden","Deleted"]
  end
  
end
