module TimeLogger

  class Employee
    attr_reader :username
    
    def initialize(username, save_data, console_ui)
      @username = username
      @save_data = save_data
      @console_ui = console_ui
      save_data.add_username(@username)
    end

    def menu_messages
      @console_ui.menu_selection_message
      menu_hash = generate_menu_hash
      @console_ui.display_menu_options(menu_hash)
      @console_ui.get_user_input
    end

    def log_time
      date_logged = @console_ui.date_log_time_message
      hours_logged = @console_ui.hours_log_time_message
      timecode_options_hash = generate_timecode_hash
      timecode_logged = @console_ui.timecode_log_time_message(timecode_options_hash)
      @save_data.add_logged_time(date_logged, hours_logged, timecode_logged) 
    end

    private
    
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
