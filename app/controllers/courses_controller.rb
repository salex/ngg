class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.json
  before_filter :login_required, :except => [:show, :index, :print]
  
    def index
      if current_group.nil?
        @courses = Course.order("id").all
      else
        @courses = current_group.courses
      end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    @tees = @course.tees.order(:id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new
    @course.group_id = @current_group.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  
  def create
    @course = Course.new(params[:course])
    @course.group_id = @current_group.id

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = current_group.courses.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = current_group.courses.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :ok }
    end
  end
  
  def print
    
    @course = current_group.courses.find(params[:id])
    @members = Member.get_active_members(@current_group) #@current_group.members.order('name ASC') #
    @imembers = Member.get_inactive_members(@current_group) #@current_group.members.order('name ASC') #
    render "print.html.erb", :layout => "print.html.erb"
  end
  
end
