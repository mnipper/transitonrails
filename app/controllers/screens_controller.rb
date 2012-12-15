class ScreensController< ApplicationController
  before_filter :find_screens, :only => [:index]
  find_model Screen, :find_current_user, :only => [:edit, :update, :show, :destroy, :screen_information] 

  respond_to :html, :json

  def index
  end

  def new
    @screen = Screen.new
  end

  def create
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
    if @screen.destroy
      flash[:success] = 'Screen successfully deleted'
      redirect_to root_path
    else
      flash[:error] = 'Error deleting screen'
      redirect_to :back
    end
  end

  def screen_information
    @screen_info = ScreenPresenter.new(@screen).data
    respond_with(@screen_info)
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
