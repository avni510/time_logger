module TimeLogger
  class Validation
    MAX_DATE_LENGTH = 10

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
      return false if date_entered.size > MAX_DATE_LENGTH
      true
    end

    def previous_date?(date_entered)
      today_date = Date.today
      date_entered = Date.strptime(date_entered,'%m-%d-%Y') 
      today_date >= date_entered
    end

    def digit_entered?(user_input)
      user_input.to_i > 0 
    end

    def blank_space?(user_input)
      not user_input !~ /^\s*$/ 
    end

    def hours_in_a_day_exceeded?(past_hours_worked, hours_entered)
      total_hours = past_hours_worked + hours_entered

      total_hours > HOURS_IN_A_DAY ? false : true
    end
  end
end

