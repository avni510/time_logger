module TimeLogger
  class LogHoursWorked

    def initialize(console_ui, validation)
      @console_ui = console_ui
      @validation = validation
    end

    def run(previous_hours_worked)
      hours_entered = @console_ui.hours_log_time_message

      hours_entered = non_digit_loop(hours_entered)

      hour_entered = exceeds_hours_in_a_day(
        previous_hours_worked, 
        hours_entered)
    end

    private

    def non_digit_loop(hours_entered)
      until @validation.digit_entered?(hours_entered)
        @console_ui.enter_digit_message
        hours_entered = @console_ui.get_user_input
      end
      hours_entered
    end

    def exceeds_hours_in_a_day(previous_hours_worked, hours_entered)
      integer_hours = hours_entered.to_i
      unless @validation.hours_in_a_day_exceeded?(previous_hours_worked, integer_hours)
        @console_ui.valid_hours_message
        return nil
      end
      hours_entered
    end
  end
end
