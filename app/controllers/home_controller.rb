class HomeController < ApplicationController
  def index
    if !is_root_domain?
      render :action => 'site'
    end
  end
  
  def site
  end

end
