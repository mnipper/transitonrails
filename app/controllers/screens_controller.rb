class ScreensController< ApplicationController
  before_filter :find_screens, :only => [:index]
  find_model Screen, :find_current_user, :only => [:edit, :update, :show, :destroy] 

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
      flash[:error] = 'Errors creating screen'
      respond_with @screen
    end
  end

  def edit
  end

  def update
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
