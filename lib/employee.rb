module TimeLogger

  class Employee
    attr_reader :username
    
    def initialize(username, save_data, console_ui, validation)
      @username = username
      @save_data = save_data
      @console_ui = console_ui
      @validation = validation
    end

    def create(username)
      @save_data.add_username(username)
    end

    def menu_messages
      @console_ui.menu_selection_message
      menu_hash = generate_menu_hash
      @console_ui.display_menu_options(menu_hash)
      @console_ui.get_user_input
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
