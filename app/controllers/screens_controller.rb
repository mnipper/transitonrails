class ScreensController< ApplicationController
  before_filter :find_screens, :only => [:index]
  find_model Screen, :find_current_user, :only => [:edit, :update, :show, :destroy] 

  def index
  end

  def new
  end

  def create
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
