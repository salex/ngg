class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.json
  load_and_authorize_resource
  before_filter :login_required, :except => [:show, :index,:teeopt,:signup,:new,:create]
  #before_filter :check_group, :except => [:index]
  
  def index
    #@groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    #@group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new
    1.times {@group.users.build}
    1.times {@group.members.build}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    #@group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    
    @group = Group.new(params[:group])
    result = @group.new_group
    respond_to do |format|
      if result
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    #@group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    #@group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :ok }
    end
  end
  
   def check_group
     if @group
       is_group_resource?(@group.id)
     end
   end
   
   def trim_rounds
     @rounds = Round.where("date < ?", (Date.today - 1000.days)).count
     @events = @current_group.events.where("date < ?", (Date.today - 1000.days)).count
     @members = Member.where('not exists (select member_id from rounds where member_id = members.id)')
     @orphan = Round.where('not exists (select id from members where id = rounds.member_id)').count
     @orphane = Round.where('not exists (select id from events where id = rounds.event_id)').count
     #:conditions => "NOT EXISTS (SELECT * FROM cities_stores WHERE cities_stores.store_type = stores.store_type)")
     #select * from members where not exists (select member_id from rounds where member_id = members.id);
     
   end
   
end
