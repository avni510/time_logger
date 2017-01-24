module TimeLogger
  module Console
    class EmployeeCreation

      def initialize(console_ui, validation_employee_creation, validation_menu)
        @console_ui = console_ui
        @validation_employee_creation = validation_employee_creation
        @validation_menu = validation_menu
      end

      def execute
        new_username = enter_new_username
        admin_option_num = enter_new_user_admin_authority
        admin_authority = convert_input_to_boolean(admin_option_num)
        employee_repo.create(new_username, admin_authority)
        employee_repo.save
      end

      private

      def employee_repo
        Repository.for(:employee)
      end

      def enter_new_username
        @console_ui.enter_new_username_message
        new_username = @console_ui.get_user_input
        valid_username_loop(new_username)
      end

      def enter_new_user_admin_authority
        @console_ui.create_admin_message
        admin_options_hash = display_admin_options
        new_user_admin_num = get_admin_authority(admin_options_hash)
      end

      def valid_username_loop(username)
        result = @validation_employee_creation.validate(username)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          username = @console_ui.get_user_input
          result = @validation_employee_creation.validate(username)
        end
        username
      end

      def display_admin_options
        admin_options_hash = generate_admin_hash
        @console_ui.display_menu_options(admin_options_hash)
        admin_options_hash
      end

      def get_admin_authority(admin_options_hash)
        admin_option_num = @console_ui.get_user_input
        valid_admin_option_loop(admin_options_hash, admin_option_num)
      end

      def valid_admin_option_loop(admin_options_hash, admin_option_num)
        result = @validation_menu.validate(admin_options_hash, admin_option_num)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          admin_option_num = @console_ui.get_user_input
          result = @validation_menu.validate(admin_options_hash, admin_option_num)
        end
        admin_option_num
      end

      def generate_admin_hash
        {
          "1": "1. yes",
          "2": "2. no"
        }
      end

      def convert_input_to_boolean(user_input)
        user_input.to_sym == generate_admin_hash.key("1. yes") ? true : false
      end
    end
  end
end
