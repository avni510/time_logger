module TimeLogger
  class Validation

    HOURS_IN_A_DAY = 24

    def menu_selection_valid?(menu_hash, user_input)
      menu_hash.key?(user_input.to_sym)
    end

    def date_valid?(date_entered)
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

    def hours_worked_valid?(hours_worked)
      return false if hours_worked !~ /^\d{0,2}$/
      hours_worked.to_i <= HOURS_IN_A_DAY 
    end

    def menu_option_valid?(menu_hash, user_input)
      menu_hash.has_key?(user_input.to_sym)
    end
  end
end

