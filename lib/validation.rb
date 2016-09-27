module TimeLogger
  class Validation

    HOURS_IN_A_DAY = 24

    def menu_selection_valid?(menu_hash, user_input)
      menu_hash.key?(user_input.to_sym)
    end

    def date_valid_format?(date_entered)
      begin
        Date.strptime(date_entered,'%m-%d-%Y')
        rescue => e
          return false
      end
      true
    end

    def previous_date?(date_entered)
      today_date = Date.today
      date_entered = Date.strptime(date_entered,'%m-%d-%Y') 
      today_date >= date_entered
    end

    def digit_entered?(user_input)
      not user_input !~ /^\d*$/
    end

    def hours_worked_per_day_valid?(previous_hours_array, hours)
      previous_hours_array = previous_hours_array.map(&:to_i)
      total_hours_entered = previous_hours_array.reduce(0, :+)
      total_hours_entered + hours.to_i > HOURS_IN_A_DAY ? false : true
    end
  end
end

