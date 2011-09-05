class HomeController < ApplicationController
  def index
    if !is_root_domain?
      @welcome = "Welcome article missing"
      show
    else
      home
    end
  end
  
  def show
    if !is_root_domain?
      case params[:id]
      when "pref"
        @group = @current_group
        @path = "pref"
      when "term"
        @path = "term"
      when "info"
        @articles = @current_group.articles.where(:published => true).paginate(:per_page => 15, :page => params[:page])
        @path = "info"
      when "photos"
        @photos = @current_group.images
        @path = "photos"
      when "blog"
        @articles = @current_group.articles.where(:published => true).paginate(:per_page => 15, :page => params[:page])
        @path = "blog"
      else
        @art_count = @current_group.articles.where(:published => true).count
        welcome = @current_group.articles.find_by_type_article("Welcome")
        if welcome
          @welcome = "### #{welcome.title} \n <br /> #{welcome.body}"
          @articles = @current_group.articles.where(:published => true).limit(2)
        else
          @welcome = "Welcome article missing"
          @articles = []
        end
      
      end
      render "show"
    else
      home
    end
  end
  
  def home
    
    case params[:id]
    when "special"
      @path = "goals"
    else
      if params[:id]
        if "goals|term|articles|photos|events|admin".include?(params[:id])
          @path = params[:id]
        end
      end
    end
    render "home"
  end
  

end
