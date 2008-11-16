class Cycle < ActiveRecord::Base

belongs_to :user
has_many :entries

  def end(current_user)
    self.current = false
    self.ended = Time.now
    self.save
    new_cycle = Cycle.new
    if self.custom1 && self.custom1.length >= 1
      new_cycle.custom1 = self.custom1
    end
    if self.custom2 && self.custom2.length >= 1
      new_cycle.custom2 = self.custom2
    end
    if self.custom3 && self.custom3.length >= 1
      new_cycle.custom3 = self.custom3
    end
    if self.custom4 && self.custom4.length >= 1
      new_cycle.custom4 = self.custom4
    end
    new_cycle.user = current_user
    new_cycle.started = Time.now
    new_cycle.save
  end
  
  #Returns the day count of the current cycle
  def current_cycle_day_count
    count = (Time.now.to_date - self.started.to_date).to_i
    if count <= 30
      return 30
    else
      return count
    end
    end
    
    def raw_day_count
      count = (Time.now.to_date - self.started.to_date).to_i + 1
      return count
    end
    
    def toggle_share(cycle_id)
       cycle = Cycle.find(cycle_id)
        if cycle.shared
          cycle.shared = false
          cycle.save
        else
          cycle.shared = true
          cycle.save
        end
    end

end
