class TeesController < ApplicationController
  # GET /tees
  # GET /tees.json
  def index
    redirect_to opps_path, :alert => "invalid path"
  end

  # GET /tees/1
  # GET /tees/1.json
  def show
    @tee = Tee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tee }
    end
  end

  # GET /tees/new
  # GET /tees/new.json
  def new
    @tee = Tee.new
    @tee.course_id = params[:course_id]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tee }
    end
  end

  # GET /tees/1/edit
  def edit
    @tee = Tee.find(params[:id])
  end

  # POST /tees
  # POST /tees.json
  def create
    @tee = Tee.new(params[:tee])
    respond_to do |format|
      if @tee.save
        format.html { redirect_to @tee, notice: 'Tee was successfully created.' }
        format.json { render json: @tee, status: :created, location: @tee }
      else
        format.html { render action: "new" }
        format.json { render json: @tee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tees/1
  # PUT /tees/1.json
  def update
    @tee = Tee.find(params[:id])

    respond_to do |format|
      if @tee.update_attributes(params[:tee])
        format.html { redirect_to @tee, notice: 'Tee was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tees/1
  # DELETE /tees/1.json
  def destroy
    @tee = Tee.find(params[:id])
    @tee.destroy

    respond_to do |format|
      format.html { redirect_to tees_url }
      format.json { head :ok }
    end
  end
end
