class HomeController < ApplicationController
  before_filter :login_required


  def index 
    @user = current_user
    @entries = current_user.current_cycle.entries.find(:all, :order => 'chart_date ASC')
    @graph = open_flash_chart_object("100%",300, 'home/y_right')#, true, '../' used to be here, too.
    @fertile_toggle = false
    if @entries.length > 0
    if @entries.last.period == true
      @fertile_toggle = true
    end
    if @entries.last.mucus == "fertile" or @entries.last.mucus == "unsure"
      @fertile_toggle = true
    end 
    if @entries.last.vaginal_sensation == "wet" or @entries.last.vaginal_sensation == "other"
      @fertile_toggle = true
    end
  end
    
  end
 
  def edit
    @user = current_user
  end

  def new_avatar
    @avatar = Avatar.new
  end

  def create_avatar
    @myavatar = current_user.avatar
    @avatar = Avatar.new(params[:avatar])
    if @myavatar
      @myavatar.destroy
    end
    if @avatar.save
      flash[:notice] = 'Avatar was successfully created.'
      @avatar.user = current_user
      @avatar.save
    end
     redirect_to :action => 'index'
  end
  
  def destroy_avatar
    @myavatar = current_user.avatar
    if @myavatar
      @myavatar.destroy
    end
    redirect_to :action => "index"
  end
  
  def edit_motto
    @user = current_user
    @user.update_attributes(params[:user])
    redirect_to :action => 'index'
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your account was successfully updated.'
      redirect_to(:action => 'index')
    else
      render :action => "edit"
    end
  end
  
  def share_cycle
    if request.post?
      cycle = Cycle.find(params[:id])
      cycle.toggle_share(cycle)
      redirect_to :action => 'index'
    end
  end
  
  def end_cycle
    if request.post?
      cycle = current_user.current_cycle  
      cycle.end(current_user)
      redirect_to :action => 'index'
    end
  end

  #=-=-=-=-=GRAPH CODE=-=-=-=-=-=
      
  def y_right
    g = Graph.new
   # g.title( 'Fertility Cycle #1', '{color: #7E97A6; font-size: 18; text-align: center}' )
    g.set_bg_color('#e7d2fc')
    
    @user = current_user
    cycle = @user.current_cycle
    entries = cycle.entries.find(:all, :order => 'chart_date ASC')
    max_entry = (entries.last.chart_date.to_date - cycle.started.to_date).to_i
    
    #Generate the amount of days in the cycle. Make the cycle 30 days long unless there are more than 30 entries.
     days = []
      if max_entry > 30
         (1..(max_entry + 1)).to_a.each do |x|
                  days << "#{x}"
                end
      else
        (1..30).to_a.each do |x|
              days << "#{x}"
        end
      end
      day_length = days.length
    
    # Create an empty array and fill it with a baseline value of 96.9 for the amount of days into the
    # cycle the latest entry exists for
    graph_array = [].fill(96.9, 0, max_entry)
    
    #Create an empty array for scatter point plots
    b = []
    
    # Now, populate that array with the actual temp values from the entries. Correspond the temp in each
    # entry to that day in the cycle.
    for entry in entries
      unless entry.temp == 0
        last_good_entry = entry.temp 
      end
      day = (entry.chart_date.to_date - @user.current_cycle.started.to_date).to_i
      temperature = entry.temp
      if entry.temp == 0
        temperature = last_good_entry
        b << Point.new(day, temperature, 8)
        
      else 
        temperature = entry.temp
      end
      
      #This is my Scatter graph for inaccurate tempss
      if entry.inaccurate
        b << Point.new(day, entry.temp, 8)        
      end
      graph_array[day] = temperature
    end
    
    # Create an empty area for a phase 2 area graph. Fill it with a baseline value of 96.9 for the amount
    # of days in the cycle.
    phase2 = [].fill(96.9, 0, day_length)
    if cycle.phase_one_end
      phase_one_end_day = (cycle.phase_one_end.to_date - cycle.started.to_date).to_i
      
      # If there's a phase_three_date attribute, make the last day of phase 2 line up with it. else, make the latest
      # entry the last day of phase 2.
      if cycle.phase_three_start
        phase_two_last_entry = (cycle.phase_three_start.to_date - cycle.started.to_date).to_i
      else
        phase_two_last_entry = max_entry
      end
      phase_two_last_entry = (phase_two_last_entry - phase_one_end_day) + 1
      phase2.fill(99, phase_one_end_day, phase_two_last_entry)
       
      # Begin Cover Line logic. 
      
      # Make sure there are six days of entries from the beginning of phase two in
      # order to do cover line logic. User has to be into phase two before this can take place.
      if  (max_entry + 1) - phase_one_end_day >= 6
        
        #Check to see if the cover line has been set already
        if cycle.cover_line_entry_day
          cover_line_temp = cycle.cover_line_entry_temp
          a = []
          hlc_offset = cycle.cover_line_entry_day - 7
          hlc_offset.times do
            a << Hlc.new(0, 0, 0)
          end
          6.times do
            a << Hlc.new(cover_line_temp, cover_line_temp, cover_line_temp) 
          end
        else    
        # Check to make sure that the temp has made at least a 0.2 degree 
        # jump over the highest temp of the last 6 days
        
        # Get the highest temp out of the last six temperatures
        cover_line_check = entries.length - 7
        the_highest_temp = entries[cover_line_check].temp
        6.times do
          if the_highest_temp <= entries[cover_line_check].temp
            the_highest_temp = entries[cover_line_check].temp
          end
          cover_line_check = cover_line_check + 1
        end
        
 
        
          hlc_offset = entries.length - 7 
          # Create empty hash for cover line graph coordinates
          a = []
          hlc_offset.times do
            a << Hlc.new(0, 0, 0)
          end
          if last_good_entry - the_highest_temp >= 0.2          
            cover_line_temp = the_highest_temp + 0.1
            6.times do
              a << Hlc.new(cover_line_temp, cover_line_temp, cover_line_temp) 
            end
            cycle.cover_line_entry_day = max_entry + 1
            cycle.cover_line_entry_temp = cover_line_temp
            cycle.save            
          end          
        end
      end
    end    
    
      # End Cover Line logic.
    
    #This is my area graph for the phases
    g.area_hollow(1,0,25,'#7f61a1', 'Phase two', 10)
    g.set_data(phase2)
      
    #This is my line graph for the waking temperatures
    g.line_dot( 5, 8, '#1f76e3', 'Waking temperature', 10 )
    g.set_data(graph_array)
    
    #This is the scatter graph for inaccurate temps
    g.scatter(b, 8, '#92a5ee', 'Possible inaccurate temp', 10)
    
    #This is the HLC graph for the cover line
    if a
      g.hlc(a, 90, 3, '#f50505', 'Cover line', 10)
    end
    

    g.set_y_min(96.9)
    g.set_y_max(99)
    g.set_x_axis_color('#7d5f9e', '#e7d2fc' )
    g.set_y_axis_color( '#7d5f9e', '#e7d2fc' )
    g.set_x_legend( 'Cycle days', 11, '#7d5f9e' )
    g.set_y_legend( 'Temp.', 11, '#7d5f9e' )
    g.set_x_labels(days)
    g.set_x_label_style(9, '#7d5f9e', 2, 1, '#818D9D' )
    g.set_y_label_style(9, '#7d5f9e')
    
    g.set_y_label_steps(21)
    tip = "Day #x_label#<br>#val# degrees"  
    g.set_tool_tip(tip)

    render :text => g.render
  end
  
end
