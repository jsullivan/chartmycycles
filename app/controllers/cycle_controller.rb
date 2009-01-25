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
        clear_phase_dates = params[:clear_phase_dates]
        clear_cover_line = params[:clear_cover_line]
        if clear_phase_dates == "1"
          @cycle.phase_one_end = nil
          @cycle.phase_three_start = nil
          @cycle.save
        end
        if clear_cover_line == "1"
          @cycle.cover_line_entry_day = nil
          @cycle.cover_line_entry_temp = nil
          @cycle.save
        end
          redirect_to(:controller => 'home', :action => 'index')
      else
        render :controller => "controller", :action => "edit"
      end
  end
  
  def period_rule_two
     if request.post?
       period_rule = params[:cycle][:period_rule_two]
       @cycle = current_user.current_cycle   
       @cycle.period_rule_two = period_rule
       @cycle.save
       redirect_to :controller => 'home', :action => 'index'
     end
   end
  
end
