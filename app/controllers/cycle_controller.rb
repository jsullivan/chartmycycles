class CycleController < ApplicationController
  layout 'home'
  def edit
    @user = current_user
    @cycle = current_user.current_cycle
  end
  
  def update
     @user = current_user
      @cycle = current_user.current_cycle
      if @cycle.update_attributes(params[:cycle])
        redirect_to(:controller => 'home', :action => 'index')
      else
        render :controller => "controller", :action => "edit"
      end
  end
  
end
