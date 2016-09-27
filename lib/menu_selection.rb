module TimeLogger
  class MenuSelection

    def initialize(username, file_name, console_ui, validation, repository)
      @username = username
      @file_name = file_name
      @console_ui = console_ui
      @validation = validation
      @repository = repository
    end

    def menu_messages
      @console_ui.menu_selection_message
      @menu_hash = generate_menu_hash
      begin
        @console_ui.display_menu_options(@menu_hash)
        user_input = @console_ui.get_user_input
        user_input = valid_menu_selection(user_input)
        menu_action(user_input)
      end until user_input.to_sym == @menu_hash.key("3. Quit the program")
    end

    private
    
    def valid_menu_selection(user_input)
      until @validation.menu_option_valid?(@menu_hash, user_input)
        @console_ui.valid_menu_option_message
        user_input = @console_ui.get_user_input
      end
      user_input
    end
    
    def menu_action(user_input)
      user_input = user_input.to_sym
      if user_input == @menu_hash.key("1. Do you want to log your time?")
        log_time = instaniate_log_time
        log_time.execute(1, @repository)
      elsif user_input == @menu_hash.key("2. Do you want to run a report on yourself?")
        report = instaniate_report
        report.execute(1, @repository)
      elsif user_input == @menu_hash.key("3. Quit the program")
#        Kernel.exit
      end
    end

    def instaniate_report
      Report.new(@console_ui)
    end

    def instaniate_log_time
      save_data = SaveJsonData.new(FileWrapper.new, @file_name)
      validation = Validation.new
      LogTime.new(@console_ui, validation)
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
