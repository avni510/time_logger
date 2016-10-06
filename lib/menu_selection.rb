module TimeLogger
  class MenuSelection

    def initialize(employee_object, console_ui)
      @employee = employee_object
      @console_ui = console_ui
      @validation = Validation.new
    end

    def run
      @console_ui.menu_selection_message
      set_menu_hash
      begin
        @console_ui.display_menu_options(@menu_hash)
        user_input = @console_ui.get_user_input
        user_input = valid_menu_selection_loop(user_input)
        menu_action(user_input)
      end until user_input.to_sym == @menu_hash.key("3. Quit the program")
    end

    private
    
    def valid_menu_selection_loop(user_input)
      until @validation.menu_selection_valid?(@menu_hash, user_input)
        @console_ui.valid_menu_option_message
        user_input = @console_ui.get_user_input
      end
      user_input
    end
    
    def menu_action(user_input)
      user_input = user_input.to_sym
      if user_input == @menu_hash.key("1. Do you want to log your time?")
        log_time = instaniate_log_time
        log_time.execute(@employee.id)
      elsif user_input == @menu_hash.key("2. Do you want to run a report on yourself?")
        report = instaniate_report
        report.execute(@employee.id)
      elsif user_input == @menu_hash.key("4. Do you want to create a client?")
        client_creation = instaniate_client_creation
        client_creation.execute
      elsif user_input == @menu_hash.key("5. Do you want to create an employee?")
        employee_creation = instaniate_employee_creation
        employee_creation.execute
      elsif user_input == @menu_hash.key("6. Do you want to run a company report?")
        admin_report = instaniate_admin_report
        admin_report.execute
      end
    end

    private

    def instaniate_admin_report
      AdminReport.new(@console_ui)
    end

    def instaniate_employee_creation
      EmployeeCreation.new(@console_ui, @validation)
    end

    def instaniate_client_creation
      ClientCreation.new(@console_ui)
    end
    
    def instaniate_report
      EmployeeReport.new(@console_ui)
    end

    def instaniate_log_time
      LogTime.new(@console_ui, @validation)
    end

    def set_menu_hash
      if @employee.admin
        @menu_hash = generate_admin_menu_hash 
      else 
        @menu_hash = generate_employee_menu_hash
      end
    end
    
    def generate_admin_menu_hash
      { 
        "1": "1. Do you want to log your time?", 
        "2": "2. Do you want to run a report on yourself?", 
        "3": "3. Quit the program",
        "4": "4. Do you want to create a client?", 
        "5": "5. Do you want to create an employee?", 
        "6": "6. Do you want to run a company report?"
      }
    end


    def generate_employee_menu_hash
      { 
        "1": "1. Do you want to log your time?", 
        "2": "2. Do you want to run a report on yourself?", 
        "3": "3. Quit the program"
      }
    end
  end
end
