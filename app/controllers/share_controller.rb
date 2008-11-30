class ShareController < ApplicationController

def cycle
  @cycle = Cycle.find(params[:id])
  @user = @cycle.user
  @entries = @cycle.entries.find(:all, :order => 'chart_date ASC')
  if @cycle.shared
    @graph = open_flash_chart_object("100%",300, "/share/y_right2/#{@cycle.id}")#, true, '../' used to be here, too.
  else
    redirect_to :controller => 'home', :action => 'index'
  end
end
  #=-=-=-=-=GRAPH CODE=-=-=-=-=-=
 
  
  def y_right2
    g = Graph.new
   # g.title( 'Fertility Cycle #1', '{color: #7E97A6; font-size: 18; text-align: center}' )
    g.set_bg_color('#e7d2fc')
    
    cycle = Cycle.find(params[:id])
     @user = cycle.user
     entries = cycle.entries.find(:all, :order => 'chart_date ASC')
    max_entry = (entries.last.chart_date.to_date - cycle.started.to_date).to_i
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
    # Now, populate that array with the actual temp values from the entries. Correspond the temp in each
    # entry to that day in the cycle. 
    for entry in entries
      day = (entry.chart_date.to_date - cycle.started.to_date).to_i
      graph_array[day] = entry.temp
    end
    #Create an empty area for a phase 2 area graph. Fill it with a baseline value of 96.9 for the amount
    # of days in the cycle.
    phase2 = [].fill(96.9, 0, day_length)
    if cycle.phase_one_end
      phase_one_end_day = (cycle.phase_one_end.to_date - cycle.started.to_date).to_i
      if cycle.phase_three_start
        phase_two_last_entry = (cycle.phase_three_start.to_date - cycle.started.to_date).to_i
      else
        phase_two_last_entry = max_entry
      end
      phase_two_last_entry = (phase_two_last_entry - phase_one_end_day) + 1
       phase2.fill(99, phase_one_end_day, phase_two_last_entry)
    end
 
    
    #This is my area graph for the phases
    g.area_hollow(0,0,25,'#7f61a1', 'Phase two', 10)
    g.set_data(phase2)
      
    #This is my line graph for the waking temperatures
    g.line_dot( 5, 8, '#1f76e3', 'Waking temperature', 10 )
    g.set_data(graph_array)

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
