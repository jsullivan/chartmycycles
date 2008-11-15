class StatsController < ApplicationController
  before_filter :login_required

  def index
   @user = current_user
   @last_cycle = @user.last_cycle
   @cycle_day_count = current_user.cycle_day_count
   
    if @last_cycle
      @last_cycle_entry_count = @last_cycle.entries.count
      @last_cycle_day_count = (@last_cycle.ended.to_date - @last_cycle.started.to_date + 1)
      @period_entries = @last_cycle.entries.find(:all, :conditions => 'period = true', :order => 'created_at ASC')
      if @period_entries.length >= 1
        @last_period_started = @period_entries.first.created_at    
      end
    end
      @graph = open_flash_chart_object('100%',300, 'stats/bar_glass', true, '')   
      @mucus_pie = open_flash_chart_object('100%',300, '/stats/mucus_pie', true, '')       
      @sensation_pie = open_flash_chart_object('100%',300, '/stats/sensation_pie', true, '')       
      @firmness_pie = open_flash_chart_object('100%',300, '/stats/firmness_pie', true, '')       
      @position_pie = open_flash_chart_object('100%',300, '/stats/position_pie', true, '')       

  end
  
  def bar_glass
    this_cycle = current_user.current_cycle
    these_entries = this_cycle.entries
    cycle_day_count = this_cycle.raw_day_count
    acne_count = 0
    cramps_count = 0
    period_count = 0
    intercourse_count = 0 
    moody_count = 0
    insomnia_count = 0
    bloating_count = 0
    these_entries.each do |x|
      if x.acne
        acne_count = acne_count + 1
      end
      if x.cramps
        cramps_count = cramps_count + 1
      end
      if x.period
        period_count = period_count + 1
      end
      if x.intercourse
        intercourse_count = intercourse_count + 1
      end
      if x.moody
        moody_count = moody_count + 1
      end
      if x.insomnia
        insomnia_count = insomnia_count + 1
      end
      if x.bloating
        bloating_count = bloating_count + 1
      end
    end
    
    if this_cycle.custom1 && this_cycle.custom1.length >= 1
      bar1_key = this_cycle.custom1.capitalize
    else
      bar1_key = "Acne"
    end
    if this_cycle.custom2 && this_cycle.custom2.length >= 1
      bar2_key = this_cycle.custom2.capitalize
    else
      bar2_key = "Cramps"
    end
    if this_cycle.custom3 && this_cycle.custom3.length >= 1
      bar3_key = this_cycle.custom3.capitalize
    else
      bar3_key = "Insomnia"
    end
    if this_cycle.custom4 && this_cycle.custom4.length >= 1
      bar4_key = this_cycle.custom4.capitalize
    else
      bar4_key = "Bloating"
    end
    
        bar1 = BarGlass.new(60, '#D54C78', '#C31812')
    bar1.key(bar1_key, 10)

    bar2 = BarGlass.new(60, '#5E83BF', '#424581')
    bar2.key(bar2_key, 10)
    
    bar3 = BarGlass.new(60, '#63d54c', '#424581')
    bar3.key('Period', 10)
    
    bar4 = BarGlass.new(60, '#d5ad4c', '#424581')
    bar4.key('Sex', 10)
    
    bar5 = BarGlass.new(60, '#d04cd5', '#424581')
    bar5.key('Moodiness', 10)

    bar6 = BarGlass.new(60, '#4cd5d3', '#424581')
    bar6.key(bar3_key, 10)

    bar7 = BarGlass.new(60, '#d5794c', '#424581')
    bar7.key(bar4_key, 10)

    1.times do |t|
            bar1.data << acne_count
            bar2.data << cramps_count
            bar3.data << period_count
            bar4.data << intercourse_count
            bar5.data << moody_count
            bar6.data << insomnia_count
            bar7.data << bloating_count
            
            
            
    end

    g = Graph.new
    g.set_bg_color('#e7d2fc')
    #g.title("Glass Bars", '{font-size:20px; color: #bcd6ff; margin:10px; background-color: #5E83BF; padding: 5px 15px 5px 15px;}')
    g.data_sets << bar1
    g.data_sets << bar2
    g.data_sets << bar3
    g.data_sets << bar4
    g.data_sets << bar5
    g.data_sets << bar6
    g.data_sets << bar7
    
    
    g.set_x_labels(%w(Trends))
    g.set_x_axis_color('#e7d2fc', '#e7d2fc')
    g.set_y_axis_color('#7d5f9e', '#e7d2fc')
    g.set_y_min(0)
    g.set_y_max(cycle_day_count)

    g.set_y_label_steps(cycle_day_count)
    g.set_y_legend("Days this cycle", 12, '#7d5f9e')
    tip = "#key#<br>#val# days"
    g.set_tool_tip(tip)
    render :text => g.render
  end
  
  def mucus_pie
    data = []
    this_cycle = current_user.current_cycle
    these_entries = this_cycle.entries
    fertile = 0
    infertile = 0
    unsure = 0
    no_entry = 0
    for entry in these_entries
      if entry.mucus && entry.mucus == 'fertile'
        fertile = fertile + 1
      elsif entry.mucus && entry.mucus == 'infertile'
        infertile = infertile + 1
      elsif entry.mucus && entry.mucus == 'unsure'
        unsure = unsure + 1
      else
        no_entry = no_entry + 1
      end
    end
    data << fertile
    data << infertile
    data << unsure
    data << no_entry
  
    g = Graph.new
    g.set_bg_color('#e7d2fc')  
    g.pie(90, '#505050', '{font-size: 12px; color: #404040;}')
    g.pie_values(data, %w(Fertile Infertile Unsure Empty))
    g.pie_slice_colors(%w(#ffffff #cc9bff #9c76c3 #48375a))
    g.set_tool_tip("#val# of #{these_entries.count} entries")
    g.title("Mucus", '{font-size:18px; color: #d01f3c}' )
    render :text => g.render
  end
  
  def sensation_pie
    data = []
    this_cycle = current_user.current_cycle
    these_entries = this_cycle.entries
    wet = 0
    dry = 0
    other = 0
    no_entry = 0
    for entry in these_entries
      if entry.vaginal_sensation && entry.vaginal_sensation == 'wet'
        wet = wet + 1
      elsif entry.vaginal_sensation && entry.vaginal_sensation == 'dry'
        dry = dry + 1
      elsif entry.vaginal_sensation && entry.vaginal_sensation == 'other'
        other = other + 1
      else
        no_entry = no_entry + 1
      end
    end
    data << wet
    data << dry
    data << other
    data << no_entry
  
    g = Graph.new
    g.set_bg_color('#e7d2fc')  
    g.pie(90, '#505050', '{font-size: 12px; color: #404040;}')
    g.pie_values(data, %w(Wet Dry Other Empty))
    g.pie_slice_colors(%w(#ffffff #cc9bff #9c76c3 #48375a))
    g.set_tool_tip("#val# of #{these_entries.count} entries")
    g.title("Sensation", '{font-size:18px; color: #d01f3c}' )
    render :text => g.render
  end
  
  def firmness_pie
     data = []
     this_cycle = current_user.current_cycle
     these_entries = this_cycle.entries
     firm = 0
     medium = 0
     soft = 0
     no_entry = 0
     for entry in these_entries
       if entry.cervix_firmness && entry.cervix_firmness == 'firm'
         firm = firm + 1
       elsif entry.cervix_firmness && entry.cervix_firmness == 'medium'
         medium = medium + 1
       elsif entry.cervix_firmness && entry.cervix_firmness == 'soft'
         soft = soft + 1
       else
         no_entry = no_entry + 1
       end
     end
     data << firm
     data << medium
     data << soft
     data << no_entry

     g = Graph.new
     g.set_bg_color('#e7d2fc')  
     g.pie(90, '#505050', '{font-size: 12px; color: #404040;}')
     g.pie_values(data, %w(Firm Medium Soft Empty))
     g.pie_slice_colors(%w(#ffffff #cc9bff #9c76c3 #48375a))
     g.set_tool_tip("#val# of #{these_entries.count} entries")
     g.title("Cervical firmness", '{font-size:18px; color: #d01f3c}' )
     render :text => g.render
   end
  
   def position_pie
       data = []
       this_cycle = current_user.current_cycle
       these_entries = this_cycle.entries
       high = 0
       medium = 0
       low = 0
       no_entry = 0
       for entry in these_entries
         if entry.cervix_position && entry.cervix_position == 'high'
           high = high + 1
         elsif entry.cervix_position && entry.cervix_position == 'medium'
           medium = medium + 1
         elsif entry.cervix_position && entry.cervix_position == 'low'
           low = low + 1
         else
           no_entry = no_entry + 1
         end
       end
       data << high
       data << medium
       data << low
       data << no_entry

       g = Graph.new
       g.set_bg_color('#e7d2fc')  
       g.pie(90, '#505050', '{font-size: 12px; color: #404040;}')
       g.pie_values(data, %w(High Medium Low Empty))
       g.pie_slice_colors(%w(#ffffff #cc9bff #9c76c3 #48375a))
       g.set_tool_tip("#val# of #{these_entries.count} entries")
       g.title("Cervical position", '{font-size:18px; color: #d01f3c}' )
       render :text => g.render
     end
  
  
end



