class HomeController < ApplicationController
  def index
    if !is_root_domain?
       @welcome = "Welcome article missing"
       
      show
    end
  end
  
  def show
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
      welcome = @current_group.articles.find_by_type_article("Welcome")
      if welcome
        @welcome = "### #{welcome.title} \n <br /> #{welcome.body}"
        @articles = @current_group.articles.where(:published => true).limit(2)
      else
        @welcome = "Welcome article missing"
      end
      
    end
    render "show"
  end
  

end

=begin

if params[:term]
  @group = @current_group
end
if params[:info]
  @articles = @current_group.articles
end

render :action => 'site'
=end