class ScreensController< ApplicationController
  before_filter :find_screens, :only => [:index]
  find_model Screen, :find_current_user, :only => [:edit, :update, :show, :destroy] 

  respond_to :html, :json

  def index
  end

  def new
    @screen = Screen.new
  end

  def create
    Time.zone = 'EST'
    @screen = Screen.new(params[:screen])
    @screen.user = current_user
    if @screen.save
      flash[:success] = 'Screen successfully created'
      redirect_to root_path
    else
      flash[:error] = 'Error creating screen'
      respond_with @screen
    end
  end

  def edit
    respond_with @screen
  end

  def update
    Time.zone = 'EST'
    @screen.update_attributes(params[:screen])
    if @screen.save
      flash[:success] = 'Screen successfully updated'
      redirect_to root_path
    else
      flash[:error] = 'Error updating screen'
      respond_with @screen
    end
  end

  def show
  end
  
  def destroy
  end


  private

  def find_current_user
    current_user
  end

  def find_screens
    if current_user
      @screens = current_user.screens
    end
  end
end
