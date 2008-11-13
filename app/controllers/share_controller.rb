class ShareController < ApplicationController

def cycle
  @cycle = Cycle.find(params[:id])
  @user = @cycle.user
  @entries = @cycle.entries.find(:all, :order => 'chart_date ASC')
  if @cycle.shared
    @graph = open_flash_chart_object("100%",300, "/share/y_right/#{@cycle.id}")#, true, '../' used to be here, too.
  else
    redirect_to :controller => 'home', :action => 'index'
  end
end
  #=-=-=-=-=GRAPH CODE=-=-=-=-=-=
  def y_right
    g = Graph.new
   # g.title( 'Fertility Cycle #1', '{color: #7E97A6; font-size: 18; text-align: center}' )
    g.set_bg_color('#e7d2fc')
    cycle = Cycle.find(params[:id])
    @user = cycle.user
    entries = cycle.entries.find(:all, :order => 'chart_date ASC')
    max_entry = (entries.last.chart_date.to_date - cycle.started.to_date).to_i
    # Create an empty array and fill it with a baseline value of 96.9 for the amount of days into the
    # cycle the latest entry exists for
    graph_array = [].fill(96.9, 0, max_entry)
    # Now, populate that array with the actual temp values from the entries. Correspond the temp in each
    # entry to that day in the cycle. 
    for entry in entries
      day = (entry.chart_date.to_date - cycle.started.to_date).to_i
      graph_array[day] = entry.temp
    end
    
    g.set_data(graph_array)
    #([98.2, 97.5, 97.6, 97.7, 97.6, 97.9, 97.7, 97.6, 97.3, 97.6, 97.6, 97.8, 97.3, 97.7, 97.8, 97.8, 97.3, 97.3, 97.5, 97.3, 97.8, 97.9, 97.7, 97.3, 97.5, 97.2, 98.3, 97.5, 97.7])
    g.line_dot( 5, 8, '#1f76e3', 'Waking temperature', 10 )
    g.set_y_min(96.9)
    g.set_y_max(99)
    g.set_x_axis_color('#7d5f9e', '#e7d2fc' )
    g.set_y_axis_color( '#7d5f9e', '#e7d2fc' )
    g.set_x_legend( 'Cycle day', 11, '#7d5f9e' )
    g.set_y_legend( 'Temp.', 11, '#7d5f9e' )
    tmp = []
    if max_entry > 30
       (1..(max_entry + 1)).to_a.each do |x|
                tmp << "#{x}"
              end
    else
      (1..30).to_a.each do |x|
            tmp << "#{x}"
      end
    end
    g.set_x_labels(tmp)
    g.set_x_label_style(9, '#7d5f9e', 2, 1, '#818D9D' )
    g.set_y_label_style(9, '#7d5f9e')
    
    g.set_y_label_steps(21)
    tip = "Day #x_label#<br>#val# degrees"
    g.set_tool_tip(tip)

    render :text => g.render
  end
  
end
