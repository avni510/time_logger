module TimeLogger
  class ValidationDate
    include Validation

    MAX_DATE_LENGTH = 10

    def validate(date_entered)
      return Result.new("Your input cannot be blank") if blank_space?(date_entered)
      return Result.new("Please enter a date in a valid format") unless date_valid_format?(date_entered)
      return Result.new("Please enter a date in the past") unless previous_date?(date_entered)
      Result.new
    end

    private

    def date_valid_format?(date_entered)
      return false if date_entered.size > MAX_DATE_LENGTH
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
  end 
end
