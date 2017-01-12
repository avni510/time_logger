module TimeLogger
  module Console
    class ClientCreation

      def initialize(console_ui, validation)
        @console_ui = console_ui
        @validation = validation
      end

      def execute
        @console_ui.new_client_name_message

        new_client_name = @console_ui.get_user_input

        new_client_name = blank_client_name_loop(new_client_name)

        new_client_name = client_exists_loop(new_client_name)

        save_client(new_client_name)
      end

      private

      def client_repo
        TimeLogger::Repository.for(:client)
      end

      def blank_client_name_loop(client_name)
        while @validation.blank_space?(client_name)
          @console_ui.valid_client_name_message
          client_name = @console_ui.get_user_input
        end
        client_name
      end

      def client_exists_loop(client_name)
        while client_repo.find_by_name(client_name)
          @console_ui.client_exists_message
          client_name = @console_ui.get_user_input
        end
        client_name
      end

      def save_client(new_client_name)
        client_repo.create(new_client_name)
        client_repo.save
      end
    end
  end
end
