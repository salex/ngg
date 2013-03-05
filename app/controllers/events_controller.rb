class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  before_filter :login_required, :except => [:show, :index, :print]
  
  def index
    @events = @current_group.events.order('date DESC').paginate(:per_page => 15, :page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = @current_group.events.find(params[:id])
    params[:event_id] = params[:id]
    @rounds = Round.search(params)
    @teams = Event.form_event_teams(@event,@current_group,@rounds) if @rounds
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    new_defaults
    respond_to do |format|
      format.html {render :action => "select"}
      format.json { render json: @event }
    end
  end

  
  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @rounds = @event.rounds
  end

  # POST /events
  # POST /events.json
  def create
    if params[:commit] != "Create"
      
      @event = Event.new(params[:event])
      _teams(params[:memb])
      if @event.valid? && @event.valid_teams(@teams,params[:event][:places].to_i)
        render :action => "add"
      else
        params[:cid] = @event.course_id
        new_defaults
        render :action => "select"
      end
    else
      @event = Event.new(params[:event])
      params[:event][:attendees].to_i.times do
        round = @event.rounds.build
      end
      
      @event.build_event(params)
      @event.status = "Add"
      @event.group_id = @current_group.id
      respond_to do |format|
        if @event.save
          format.html { redirect_to @event, notice: 'Event was successfully created.' }
          format.json { render json: @event, status: :created, location: @event }
        else
          format.html { render action: "add" }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
      
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
  private
  
  def new_defaults
    
    @event.group_id = @current_group.id
    @members = Member.get_active_members(@current_group) #@current_group.members.order('name ASC') #
    @imembers = Member.get_inactive_members(@current_group) #@current_group.members.order('name ASC') #
    
    if !params[:cid]
      params[:cid] = @current_group.courses.first
    end
    @event.course_id = params[:cid]
  end
  
  def _teams(memb)
    teams = {}
    indv = 0
    members = 0
    memb.each do |key,value|
      if value != ""
        members += 1
        if value == "Indiv"
          indv += 1
          value = indv.to_s
        end
        memb_id = key.to_i
        if teams.has_key?(value)
          teams[value] << memb_id
        else
          teams[value] = [memb_id]
        end
      end
    end
    pot = @current_group.splitPot(members,params[:event][:places].to_i)
    @pots = {members: members, team_pot: pot, skins_pot: (@current_group.skins_dues * members)}
    @teams = teams
  end
end
