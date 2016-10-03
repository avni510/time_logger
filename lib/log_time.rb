module TimeLogger
  class LogTime
    def initialize(console_ui, validation)
      @console_ui = console_ui
      @validation = validation
    end

    def execute(employee_id)
      log_date 
      log_hours_worked(employee_id)
      log_timecode

      if @timecode_entered == "Billable"
        all_clients = client_repo.all
      end
      
      log_time_repo.create(employee_id, @date_entered, @hours_entered, @timecode_entered)
      log_time_repo.save
    end

    private

    def log_time_repo
      Repository.for(:log_time)
    end

    def client_repo
      Repository.for(:client)
    end

    def log_date
      @date_entered = @console_ui.date_log_time_message
      @date_entered = valid_date_format_loop
      future_date_loop
    end

    def log_hours_worked(employee_id)
      @hours_entered = @console_ui.hours_log_time_message
      @hours_entered = digit_loop
      exceeds_hours_in_a_day(employee_id)
    end

    def log_timecode
      timecode_options_hash = generate_timecode_hash
      timecode_num_entered = @console_ui.timecode_log_time_message(timecode_options_hash)
      timecode_num_entered = valid_timecode_loop(timecode_options_hash, timecode_num_entered)
      timecode_type = timecode_options_hash[timecode_num_entered.to_sym]
      @timecode_entered = timecode_type[3..-1]
    end

    def valid_date_format_loop
      until @validation.date_valid_format?(@date_entered)
        @console_ui.valid_date_message
        @date_entered = @console_ui.get_user_input
      end
      @date_entered
    end
    
    def future_date_loop
      until @validation.previous_date?(@date_entered)
        @console_ui.future_date_valid_message
        @date_entered = @console_ui.get_user_input
      end
      @date_entered
    end

    def digit_loop
      until @validation.digit_entered?(@hours_entered)
        @console_ui.enter_digit_message
        @hours_entered = @console_ui.get_user_input
      end
      @hours_entered
    end

    def exceeds_hours_in_a_day(employee_id)
      log_time_entries = log_time_repo.find_by_employee_id_and_date(employee_id, @date_entered)
      unless @validation.hours_worked_per_day_valid?(log_time_entries, @hours_entered)
        @console_ui.valid_hours_message
        execute(employee_id)
      end
      @hours_entered
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
