module TimeLogger
  class LogTime
    def initialize(console_ui, validation)
      @console_ui = console_ui
      @validation = validation
    end

    def execute(employee_id, repository)
      date_logged = log_date 
      hours_logged = log_hours_worked
      timecode_logged = log_timecode
      #add ability to select client 
      log_time_repo = repository.for(:log_time)
      log_time_repo.create(employee_id, date_logged, hours_logged, timecode_logged)
      log_time_repo.save
    end

    private

    def log_date
      date_entered = @console_ui.date_log_time_message
      date_entered = valid_date_loop(date_entered)
      date_entered = valid_previous_date(date_entered)
    end

    def log_hours_worked
      hours_entered = @console_ui.hours_log_time_message
      hours_entered = valid_hours_loop(hours_entered)
    end

    def log_timecode
      timecode_options_hash = generate_timecode_hash
      timecode_num_entered = @console_ui.timecode_log_time_message(timecode_options_hash)
      timecode_num_entered = valid_timecode_loop(timecode_options_hash, timecode_num_entered)
      timecode_type = timecode_options_hash[timecode_num_entered.to_sym]
      timecode_type = timecode_type[3..-1]
    end

    def valid_date_loop(date_entered)
      until @validation.date_valid?(date_entered)
        @console_ui.valid_date_message
        date_entered = @console_ui.get_user_input
      end
      date_entered
    end
    
    def valid_previous_date(date_entered)
      until @validation.previous_date?(date_entered)
        @console_ui.future_date_valid_message
        date_entered = @console_ui.get_user_input
      end
      date_entered
    end

    def valid_hours_loop(hours_entered)
      until @validation.hours_worked_valid?(hours_entered)
        @console_ui.valid_hours_message
        hours_entered = @console_ui.get_user_input
      end
      hours_entered
    end

    def valid_timecode_loop(timecode_options_hash, timecode_entered)
      until @validation.menu_selection_valid?(timecode_options_hash, timecode_entered)
        @console_ui.valid_menu_option_message
        timecode_entered = @console_ui.get_user_input
      end
      timecode_entered
    end

    def generate_timecode_hash
      { 
        "1": "1. Billable", 
        "2": "2. Non-Billable",
        "3": "3. PTO"
      }
    end
  end
end
