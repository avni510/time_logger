module TimeLogger
  class ConsoleRunner

    def initialize(console_ui, save_data, validation, file_name)
      @console_ui = console_ui
      @save_data = save_data
      @validation = validation
      @file_name = file_name
    end

    def run
      @console_ui.username_display_message
      username = @console_ui.get_user_input
      # Validation that the employee entered exists 

      @worker = Employee.new(username, @save_data)

      menu_selection = MenuSelection.new(username, @file_name, @console_ui, @validation)

      menu_selection.menu_messages
    end
  end
end
