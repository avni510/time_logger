module TimeLogger
  module Console
    class MenuSelection

      def initialize(employee_object, console_ui)
        @employee = employee_object
        @console_ui = console_ui
      end

      def run
        @console_ui.menu_selection_message
        menu_hash = set_menu_hash
        user_selection = true
        while user_selection
          @console_ui.display_menu_options(menu_hash)
          user_input = @console_ui.get_user_input
          user_input = valid_menu_selection_loop(menu_hash, user_input)
          break if user_input.to_sym == menu_hash.key("3. Quit the program")
          menu_action(user_input)
        end 
      end
      
      private
      def log_time_repo
        Repository.for(:log_time)
      end

      def employee_repo
        Repository.for(:employee)
      end

      def client_repo
        Repository.for(:client)
      end

      def valid_menu_selection_loop(menu_hash, user_input)
        result = validation_menu.validate(menu_hash, user_input)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          user_input = @console_ui.get_user_input
          result = validation_menu.validate(menu_hash, user_input)
        end
        user_input
      end
      
      def menu_action(user_input)
        user_input = user_input.to_sym
        action = menu_action_hash[user_input]
        action.execute
      end

      def menu_action_hash
        {
          "1": instaniate_log_time,
          "2": instaniate_employee_report,
          "4": instaniate_client_creation, 
          "5": instaniate_employee_creation, 
          "6": instaniate_admin_report
        }
      end

      def validation_hours_worked
        TimeLogger::ValidationHoursWorked.new
      end

      def validation_menu
        TimeLogger::ValidationMenu.new
      end

      def validation_date
        TimeLogger::ValidationDate.new
      end

      def validation_log_time
        TimeLogger::ValidationLogTime.new(
          validation_date, 
          validation_hours_worked, 
          log_time_repo
        )
      end

      def validation_client_creation
        TimeLogger::ValidationClientCreation.new(client_repo)
      end

      def validation_employee_creation
        TimeLogger::ValidationEmployeeCreation.new(employee_repo)
      end

      def instaniate_admin_report
        AdminReport.new(@console_ui)
      end

      def instaniate_employee_creation
        EmployeeCreation.new(@console_ui, validation_employee_creation, validation_menu)
      end

      def instaniate_client_creation
        ClientCreation.new(@console_ui, validation_client_creation)
      end
      
      def instaniate_employee_report
        EmployeeReport.new(@console_ui, @employee.id)
      end

      def instaniate_log_time
        log_time_hash = generate_log_time_hash
        LogTime.new(log_time_hash)
      end

      def set_menu_hash
        if @employee.admin
          generate_admin_menu_hash 
        else 
          generate_employee_menu_hash
        end
      end

      def generate_log_time_hash
        { 
          :log_date => LogDate.new(@console_ui, validation_log_time),
          :log_hours_worked => LogHoursWorked.new(@console_ui, validation_log_time),
          :log_timecode => LogTimecode.new(@console_ui, validation_menu),
          :log_client => LogClient.new(@console_ui, validation_menu),
          :employee_id => @employee.id
        }
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
end
