module UsersHelper
  def role_select(f)
    if @current_user.role?("super")
      f.select :roles, ["super","member","admin","coordinator","scorer","upload","guest"], {},{:multiple => true}
    else
      f.select :roles, ["member","admin","coordinator","scorer","upload","guest"], {},{:multiple => true}
    end
  end
  def role_options
    if @current_user.role?("super")
      return ["super","member","admin","coordinator","scorer","upload","guest"]
    else
      return ["member","admin","coordinator","scorer","upload","guest"]
    end
  end
  
  
end
