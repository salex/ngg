class MembersController < ApplicationController
  # GET /members
  # GET /members.json
  load_and_authorize_resource
  
  before_filter :login_required, :except => [:show, :index,:teeopt]
  before_filter :check_group, :except => [:index,:new,:create]
  
  def index
    @members = Member.get_active_members(@current_group) #@current_group.members.order('name ASC') #
    @imembers = Member.get_inactive_members(@current_group) #@current_group.members.order('name ASC') #
    @dmembers = Member.get_deleted_members(@current_group) #@current_group.members.order('name ASC') #
    #filepath = Rails.root.join("db/conversion","members.json")
    #json = @members.to_json
    #File.open(filepath,'w') {|f| f.write(json)}
    #puts "Wrote member records as JSON"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    #@member = Member.find(params[:id])
    #@member =  @current_group.members.find(params[:id])
    #@rounds = @member.rounds.paginate(:per_page => 15, :page => params[:page])
    params[:member_id] = @member.id
    @rounds = Round.search(params).paginate(:per_page => 15, :page => params[:page])
    @user = @member.user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/new
  # GET /members/new.json
  def new
    @member = Member.new
    @member.group_id = session[:group_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/1/edit
  def edit
    #@member = Member.find(params[:id])
    @user = @member
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(params[:member])
    @member.group_id = session[:group_id]

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    #@member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    #@member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_url }
      format.json { head :ok }
    end
  end
  
  def check_group
    if @member
       logger.info "CURRENT MEMBER #{@member}"
       
      is_group_resource?(@member.group_id)
    end
  end
  
  def invite
    if @member.user
      flash[:error] = 'Member already a user.'
    else
      @member.invite_user
      flash[:notice] = "Member Invited #{@member.name}"
      
    end
    redirect_to member_path(@member)
  end

  def teeopt
    m =  Member.find(params[:id])
    c = Course.find(params[:course])
    t = Tee.get_tees(c.id)
    teeopt = ""
    membOpt = []
    cnt = 0
    for tee in t 
      quota, limited = m.get_member_quota(tee.id)
      star = limited ? "*" : ""
      val = {"quota" => quota,"star" => star,"limited" => limited, "tee" => tee.id, "color" => tee.color, "membID" => m.id }
      if m.tee == tee.tee
        sel = 'selected="selected"'
        val["selected"] = true
      else
        sel = ""
        val["selected"] = false
      end
      membOpt << val
      #teeopt += '<option value="'+quota.to_s+star+'_'+tee.id.to_s+'" ' + sel + '>'+tee.color+":"+quota.to_s+star+'</option>'
      teeopt += '<option value="'+ cnt.to_s + '"' + sel+ '>'+tee.color+":"+quota.to_s+star+'</option>'
      cnt += 1
    end
    obj = {"teeopt" => teeopt, "membopt" => membOpt, "group" => @current_group.options}.to_json
    render :text => obj
  end


end

