module TimeLogger
  module Console
    class EmployeeCreation

      def initialize(console_ui, validation)
        @console_ui = console_ui
        @validation = validation
      end

      def execute
        new_username = enter_new_username

        admin_option_num = enter_new_user_admin_authority

        save_user(new_username, admin_option_num)
      end

      private

      def employee_repo
        TimeLogger::Repository.for(:employee)
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
        username = blank_employee_name_loop(username)
        employee_exists_loop(username)
      end

      def employee_exists_loop(username)
        while employee_repo.find_by_username(username)
          @console_ui.username_exists_message
          username = @console_ui.get_user_input
        end
        username
      end

      def blank_employee_name_loop(username)
        while @validation.blank_space?(username)
          @console_ui.valid_username_message
          username = @console_ui.get_user_input
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
        until @validation.menu_selection_valid?(admin_options_hash, admin_option_num)
          @console_ui.valid_menu_option_message
          admin_option_num = @console_ui.get_user_input
        end
        admin_option_num
      end

      def save_user(username, admin_num_value)
        new_admin_value = convert_input_to_boolean(admin_num_value)
        employee_repo.create(username, new_admin_value)
        employee_repo.save
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
