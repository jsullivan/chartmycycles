# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def select_with_integer_options (object, column, start, stop, default = nil)  
    output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
    for i in start..stop  
      output << "\n<option value=\"#{i}\""  
      output << " selected=\"selected\"" if i == default  
      output << ">#{i}"  
    end  
    output + "</select>"  
  end
  
  def select_with_temp_options (object, column, hash, select_class)  
    output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
    for i in hash 
      i.to_i 
      output << "\n<option value=\"#{i}\""  
     output <<  " selected=\"#{select_class}\"" if i == select_class 
      output << ">#{i}"  
    end  
    output + "</select>"  
  end
  
  def select_with_sensation_options (object, column, hash, select_class)  
    output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\" blank='true'>"  
    for i in hash 
      i.to_i 
      output << "\n<option value=\"#{i}\""  
     output <<  " selected=\"#{select_class}\"" if i == select_class 
      output << ">#{i}"  
    end  
    output + "</select>"  
  end
  
  def select_with_mucus_options (object, column, hash, select_class)  
     output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
     for i in hash 
       i.to_i 
       output << "\n<option value=\"#{i}\""  
      output <<  " selected=\"#{select_class}\"" if i == select_class 
       output << ">#{i}"  
     end  
     output + "</select>"  
   end
   
   def select_with_cervix_position_options (object, column, hash, select_class)  
      output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
      for i in hash 
        i.to_i 
        output << "\n<option value=\"#{i}\""  
       output <<  " selected=\"#{select_class}\"" if i == select_class 
        output << ">#{i}"  
      end  
      output + "</select>"  
    end
    
     def select_with_cervix_firmness_options (object, column, hash, select_class)  
        output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
        for i in hash 
          i.to_i 
          output << "\n<option value=\"#{i}\""  
         output <<  " selected=\"#{select_class}\"" if i == select_class 
          output << ">#{i}"  
        end  
        output + "</select>"  
      end
  
  def nice_date(date)
      h date.strftime("%b %d, %Y")
   end
   
   def nice_date_no_year(date)
       h date.strftime("%b %d")
    end
    
   def nice_time(date)
      h date.strftime("%H:%M, %m-%d-%y")
   end
   
   def sensation_hash
     sensation_hash = ["", "wet", "dry", "other"]
   end

   def mucus_hash
      mucus_hash = ["", "fertile", "infertile", "unsure"]
    end
    
     def position_hash
        position_hash = ["", "high", "middle", "low"]
      end
      
      def firmness_hash
          firmness_hash = ["", "firm", "medium", "soft"]
        end
   
   def degree_hash
     degree_hash = [99, 98.9, 98.8, 98.7, 98.6, 98.5, 98.4, 98.3, 98.2, 98.1, 98, 97.9, 97.8, 97.7, 97.6, 97.5, 97.4, 97.3, 97.2, 97.1, 97, 96.9]
  end
  
  
end
