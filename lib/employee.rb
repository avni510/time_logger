require 'pry'
module TimeLogger

  class Employee
    attr_reader :username
    
    def initialize(username, save_data, console_ui, validation)
      @username = username
      @save_data = save_data
      @console_ui = console_ui
      @validation = validation
      save_data.add_username(@username)
    end

    def menu_messages
      @console_ui.menu_selection_message
      menu_hash = generate_menu_hash
      @console_ui.display_menu_options(menu_hash)
      @console_ui.get_user_input
    end

    def log_time
      date_logged = log_date 
      hours_logged = log_hours_worked
      timecode_logged = log_timecode
      @save_data.add_logged_time(@username, date_logged, hours_logged, timecode_logged) 
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
      timecode_entered = @console_ui.timecode_log_time_message(timecode_options_hash)
      valid_timecode_loop(timecode_options_hash, timecode_entered)
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
        "1": "Billable", 
        "2": "Non-Billabe",
        "3": "PTO"
      }
    end

    def generate_menu_hash
      { 
        "1": "1. Do you want to log your time?", 
        "2": "2. Do you want to run a report on yourself?", 
        "3": "3. Quit the program"
      }
    end
  end
end
