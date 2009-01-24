class HomeController < ApplicationController
  before_filter :login_required


  def index 
    @user = current_user
    @cycle = @user.current_cycle
    @entries = @cycle.entries.find(:all, :order => 'chart_date ASC')
    @graph = open_flash_chart_object("100%",300, "home/y_right/#{@cycle.id}")#, true, '../' used to be here, too.
    @fertile_toggle = 0
    if @entries.length > 0
      if @entries.last.period == true
        @fertile_toggle = 1
      end
      if @entries.last.mucus == "fertile" or @entries.last.mucus == "unsure"
        @fertile_toggle = 1
      end 
      if @entries.last.vaginal_sensation == "wet" or @entries.last.vaginal_sensation == "other"
        @fertile_toggle = 1
      end
     if @cycle.phase_three_start
       @fertile_toggle = 0
       if @entries.last.mucus == "fertile" or @entries.last.mucus == "unsure"
         @fertile_toggle = 2
       end
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
      redirect_to :back
    end
  end
  
  def end_cycle
    if request.post?
      cycle = current_user.current_cycle  
      cycle.end(current_user)
      redirect_to :action => 'index'
    end
  end

  def create_about
    if request.post?
      about = params[:user][:about]
      if about.length > 1
        current_user.about = About.new
        current_user.about.body = about
        current_user.about.save
        redirect_to :controller => 'forums'
      end
    end
  end
  
#=-=-=-=-=GRAPH CODE=-=-=-=-=-=
      
  def y_right
    g = Graph.new
    g.set_bg_color('#e7d2fc')
    cycle = Cycle.find(params[:id])
      @user = cycle.user
   # @user = current_user
  #  cycle = @user.current_cycle
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
      day = (entry.chart_date.to_date - cycle.started.to_date).to_i
      temperature = entry.temp
      if entry.temp == 0
        temperature = last_good_entry
        b << Point.new(day, temperature, 8)
        
      else 
        temperature = entry.temp
      end
      
      #INACURRATE TEMPS SCATTER GRAPH
      if entry.inaccurate
        b << Point.new(day, entry.temp, 8)        
      end
      graph_array[day] = temperature
    end
    
    #PHASE II LOGIC AND AREA GRAPH
    # Create an empty area for a phase 2 area graph. Fill it with a baseline value of 96.9 for the amount
    # of days in the cycle.
    phase2 = [].fill(96.9, 0, day_length)
    if cycle.phase_one_end
      phase_one_end_day = (cycle.phase_one_end.to_date - cycle.started.to_date).to_i
=begin
If there's a phase_three_date attribute, make the last day of phase 2 line up with it. else, make the latest
entry the last day of phase 2.
=end
      if cycle.phase_three_start?
        phase_two_ending = (cycle.phase_three_start.to_date - cycle.started.to_date).to_i - phase_one_end_day + 1
         # Now populate the area graph for phase 2
        phase2.fill(99, phase_one_end_day, phase_two_ending)
      else
=begin 
If there is a cover line drawn already, check to see if there have been three consecutive temps above
the cover line. if there have, declare the end of phase two (the start of phase three). If there haven't
been three consecutive temps above the cover line, check to see if there have been 4 days of infertile
mucus since the cover line was drawn. If yes, declare end of phase two (start of phase three). 
Otherwise, keep user in phase two.
=end
        if cycle.cover_line_entry_day?
          total_entries_since_cover_line = max_entry - cycle.cover_line_entry_day + 1
=begin      
Check to see if there are 3 or more entries since cover line
=end
          if total_entries_since_cover_line >= 3
            cover_line_temp = cycle.cover_line_entry_temp
            entry_day_temp_check = cycle.cover_line_entry_day - 1
            entry_day_mucus_check = cycle.cover_line_entry_day - 1
            
=begin    
Loop through the same amount of times as there are entries since cover line entry day.
Check to see if there are three consecutive temps above the cover line. Here's how it works.
I create an empty hash. Each new entry is checked to see if its temp is above the cover line.
            
If it is, add the chart_date to the temp_check hash. Then, check the temp_check hash length.
If the length = 2 (three entries, 0,1,2) then populate the end_phase_two variable with the value of 
the third string in the hash, which is the chart_date of that last temp. That chart_date is what 
triggers the end of phase 2.
=end
            temp_check = []
            total_entries_since_cover_line.times do
              if (entries[entry_day_temp_check].temp - cover_line_temp) >= 0.1 
                temp_check << entries[entry_day_temp_check].chart_date
                if temp_check.length == 3
                  cycle.phase_three_start = temp_check[2].to_date
                  cycle.save
                end 
              else
                temp_check.clear
              end
              entry_day_temp_check = entry_day_temp_check + 1
            end
            if !cycle.phase_three_start?
              infertile_mucus_check = []
              entry_day_mucus_check = cycle.cover_line_entry_day - 1
              total_entries_since_cover_line.times do
                if entries[entry_day_mucus_check].mucus == "dry"
                  infertile_mucus_check << entries[entry_day_mucus_check].chart_date
                  if infertile_mucus_check.length == 4
                    cycle.phase_three_start = infertile_mucus_check[3].to_date
                    cycle.save
                  end
                end
                entry_day_mucus_check = entry_day_mucus_check + 1
                            
              end
            end
=begin
Now check to see if there are three consecutive entries in the temp_check hash. if so, make 
the phase_two_last_entry the entry day number that will end phase two. otherwise, make the
phase_two_last_entry the entry day of the most recent entry (max_entry).
=end
          end
        else
          phase_two_end_day = (max_entry - phase_one_end_day) + 1
        end
        if cycle.phase_three_start
          phase_two_end_day = (cycle.phase_three_start.to_date - cycle.started.to_date).to_i - phase_one_end_day + 1   
        else
          phase_two_end_day = (max_entry - phase_one_end_day) + 1
        end  
        phase2.fill(99, phase_one_end_day, phase_two_end_day)
      end
             
      # COVER LINE HLC GRAPH 
      
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
    if cycle.phase_one_end
      g.area_hollow(1,0,25,'#7f61a1', 'Phase two', 10)
      g.set_data(phase2)
    end
    
    #This is my line graph for the waking temperatures
    g.line_dot( 5, 8, '#1f76e3', 'Waking temperature', 10 )
    g.set_data(graph_array)
    
    #This is the scatter graph for inaccurate temps
    if b.length >= 1
      g.scatter(b, 2, '#1f76e3', 'Possible inaccurate temp', 10)
    end
    
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
