class HomeController < ApplicationController
  before_filter :login_required


  def index 
    @user = current_user
    @entries = current_user.current_cycle.entries.find(:all, :order => 'chart_date ASC')
    @graph = open_flash_chart_object("100%",300, 'home/y_right')#, true, '../' used to be here, too.
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
  
  def toggle_share_it
    if request.post?
      cycle = current_user.current_cycle
      if cycle.shared
        cycle.shared = false
        cycle.save
      else
        cycle.shared = true
        cycle.save
      end
    end
    redirect_to :action => 'index'
  end
  
  def end_cycle
    if request.post?
      cycle = current_user.current_cycle  
      cycle.end(current_user)
      redirect_to :action => 'index'
    end
  end
  
  #=-=-=-==-=COMMENT CODE=-=-=-=-
  
  def insomnia_comment
    entry = Entry.find(params[:entry_id])
    insomnia_comment = InsomniaComment.new
    insomnia_comment.entry = entry
    insomnia_comment.update_attributes(params[:insomnia_comment])
    redirect_to :action => 'home'
 #   render :action => 'comment_insomnia', @tall_attributes_div = params[:tall_attributes] 
  end

  #=-=-=-=-=GRAPH CODE=-=-=-=-=-=
  
 
     
  def y_right
    g = Graph.new
   # g.title( 'Fertility Cycle #1', '{color: #7E97A6; font-size: 18; text-align: center}' )
    g.set_bg_color('#e7d2fc')
    
    @user = current_user
    cycle = @user.current_cycle
    entries = cycle.entries.find(:all, :order => 'chart_date ASC')
    max_entry = (entries.last.chart_date.to_date - @user.current_cycle.started.to_date).to_i
    # Create an empty array and fill it with a baseline value of 96.9 for the amount of days into the
    # cycle the latest entry exists for
    graph_array = [].fill(96.9, 0, max_entry)
    # Now, populate that array with the actual temp values from the entries. Correspond the temp in each
    # entry to that day in the cycle. 
    for entry in entries
      day = (entry.chart_date.to_date - @user.current_cycle.started.to_date).to_i
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
