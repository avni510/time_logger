module TimeLogger
  class LogDate
    
    def initialize(console_ui, validation)
      @console_ui = console_ui
      @validation = validation
    end

    def run
      date_entered = @console_ui.date_log_time_message

      date_entered = valid_date_format_loop(date_entered)

      date_entered = future_date_loop(date_entered)
    end
    
    private

    def valid_date_format_loop(date_entered)
      until @validation.date_valid_format?(date_entered)
        @console_ui.valid_date_message
        date_entered = @console_ui.get_user_input
      end
      date_entered
    end

    def future_date_loop(date_entered)
      until @validation.previous_date?(date_entered)
        @console_ui.future_date_valid_message
        date_entered = @console_ui.get_user_input
      end
      date_entered
    end
  end
end
