class EntryController < ApplicationController
layout 'home'

def new
end

def create
  current_cycle = Cycle.find(current_user.current_cycle)
  start_date = current_cycle.started
  entries = current_cycle.entries.find(:all, :order => 'chart_date ASC')
  entry_check = []
  for entry in entries
    day = (entry.chart_date.to_date - current_user.current_cycle.created_at.to_date).to_i
    entry_check << day
  end
  this_entry = (params[:chart].to_date - current_user.current_cycle.created_at.to_date).to_i
  if entry_check.include?(this_entry)
    redirect_to :controller => 'home', :action => 'index'
    flash[:notice] = "You have already charted on this day."
  else 
  entry = Entry.new
 
  chart_day = params[:chart]  
  form = params[:entry]
  entry.chart_date = chart_day
  entry.user = current_user
  entry.cycle = current_cycle
  entry.update_attributes(form)
  if params[:entry][:temp] == "--"
     entry.temp = "0"
   end
  entry.save
  if entry.mucus == "fertile"
    unless entry.cycle.phase_one_end
      entry.cycle.phase_one_end = chart_day
      entry.cycle.save
    end
  end
  redirect_to :controller => 'home', :action => 'index'
end
end

def edit_entry
  @entry = Entry.find(params[:id])
  @user = current_user
  @history = params[:history_id]
end

def update
   @entry = Entry.find(params[:entry_id])
    if @entry.update_attributes(params[:entry])
      if params[:entry][:temp] == "--"
         @entry.temp = "0"
       end
       chart_day = params[:chart]
       @entry.chart_date = chart_day
       @entry.save
       if @entry.mucus == "fertile"
          unless @entry.cycle.phase_one_end
            current_cycle.phase_one_end = chart_day
            entry.cycle.save
          end
        end
      history = params[:history_id]
      if history && history.length >= 1
        cycle = Cycle.find(params[:history_id])
        redirect_to(:controller => 'history', :action => 'details', :id => cycle)
      else
        redirect_to(:controller => 'home', :action => 'index')
      end
    else
      render :controller => "home", :action => "edit_entry"
    end
end    
    
def destroy
    entry = Entry.find(params[:id])
    entry.destroy
    if params[:history_id]
      cycle = Cycle.find(params[:history_id])
      redirect_to(:controller => 'history', :action => 'details', :id => cycle)
    else
      redirect_to :controller => 'home', :action => 'index'
    end
end


end
