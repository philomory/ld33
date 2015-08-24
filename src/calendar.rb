module Calendar
  SEASONS = %i{winter spring summer fall}
  TIMES_OF_DAY = %i{day night}
  DAYS_IN_SEASON = 10
  class << self
    def reset!
      year = rand(460..495)
      season = rand(1..3)
      day = 1
      time_of_day = 0
      @tick = time_of_day + (day * TIMES_OF_DAY.size) + (season * TIMES_OF_DAY.size * DAYS_IN_SEASON) + (year * TIMES_OF_DAY.size * DAYS_IN_SEASON * SEASONS.size) 
    end
  
    def tick!
      @tick += 1
    end
  
    def time_of_day_index
      @tick % TIMES_OF_DAY.size
    end
  
    def time_of_day
      TIMES_OF_DAY[time_of_day_index]
    end
  
    def day
      ((@tick / TIMES_OF_DAY.size) % DAYS_IN_SEASON) + 1
    end
  
    def season_index
      (@tick / (TIMES_OF_DAY.size * DAYS_IN_SEASON)) % SEASONS.size
    end
  
    def season
      SEASONS[season_index]
    end
  
    def year
      (@tick / (TIMES_OF_DAY.size * DAYS_IN_SEASON * SEASONS.size))
    end
    
  end
end