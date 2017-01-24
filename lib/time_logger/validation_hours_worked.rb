module TimeLogger
  class ValidationHoursWorked
    include Validation

    HOURS_IN_A_DAY = 24

    def validate(past_hours_worked = 0, hours_worked_entered)
      return Result.new("Your input cannot be blank") if blank_space?(hours_worked_entered)
      return Result.new("Please enter a number greater than 0") unless digit_entered?(hours_worked_entered)
      return Result.new("You have exceeded 24 hours for this day.", :exceeds_24_hours) if hours_in_a_day_exceeded?(past_hours_worked, hours_worked_entered)
      Result.new
    end

    private

    def digit_entered?(user_input)
      user_input.to_i > 0 
    end

    def hours_in_a_day_exceeded?(past_hours_worked, hours_entered)
      total_hours = past_hours_worked + hours_entered.to_i
      total_hours > HOURS_IN_A_DAY ? true : false
    end
  end
end
