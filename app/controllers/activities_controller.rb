class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :require_ownership, only: [:edit, :update, :destroy]
  before_action :require_authorization, only: [:index, :summary, :show]

  # GET /activities
  # GET /activities.json
  def index

    weeks_ago = params[:weeks_ago] || 0
    date = Date.current.weeks_ago(weeks_ago)

    @activities = Activity
      .all
      .ofWeek(date: date)
      .forUser(current_user.id)
  end

  # GET /summary
  # GET /summary.json
  def summary
    @summary = Activity.summary(user: current_user, date: Date.current)
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    # I want links to individual records bookmarkable
    # and available via login splash
    # so the auth error should only be raised
    # after the login if the user is wrong
    raise ApplicationController::NotAuthorized unless @activity.user == current_user
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

  def require_authorization
      redirect_to(user_session_path) unless user_signed_in?
  end

  def require_ownership
    raise ApplicationController::NotAuthorized unless @activity.user == current_user
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:user_id, :activity_type, :activity_date, :hours, :minutes)
    end
end
