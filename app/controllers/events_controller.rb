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
    respond_to do |format|
      
      if @event.status == "New"
        @members = Member.get_active_members(@current_group) #@current_group.members.order('name ASC') #
        @imembers = Member.get_inactive_members(@current_group) #@current_group.members.order('name ASC') #
        format.html { render action: "add" }
        format.json { render json: @event }
      else
        format.html # show.html.erb
        format.json { render json: @event }
      end
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    @event.group_id = @current_group.id
    if !params[:cid]
      params[:cid] = @current_group.courses.first
    end
    @event.course_id = params[:cid]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @rounds = @event.rounds
  end

  def add
    @event = Event.find(params[:id])
    @teams = Event.form_teams(params,@current_group, @event) 	
    
    respond_to do |format|
      format.html { render action: "verify" } # new.html.erb
      format.json  { render :json => @event }
    end
  end
  
  def verify
    @event = Event.find(params[:id])
    maxp = 0
    minp = 0
    tot = 0
    cnt = params["round"]["points"].length
    params["round"]["points"].each do |key,val|
      pts = val.to_i
      tot += pts
      if pts > maxp
        maxp = pts
      end
      if pts < minp
        minp = pts
      end
    end
    avg = tot / cnt
    
    @event.remarks =  params["event"]["remarks"] +" {High:"+maxp.to_s+", Low:"+minp.to_s+ ", Average:"+avg.to_s+"}"
    Round.create_from_event(@event,params,@current_group)
    
    
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Members was successfully added to Event.'
        format.html { redirect_to(@event) }
        format.json  { render :json => @event, :status => :created, :location => @event }
      else
        format.html { redirect_to(@event) }
        format.json  { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    @event.group_id = @current_group.id
    @event.status = "New"
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
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
end
