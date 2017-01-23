module TimeLogger
  module Console
    class ClientCreation

      def initialize(console_ui, validation_client_creation)
        @console_ui = console_ui
        @validation_client_creation = validation_client_creation
      end

      def execute
        @console_ui.new_client_name_message
        new_client_name = @console_ui.get_user_input
        result = @validation_client_creation.validate(new_client_name)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          new_client_name = @console_ui.get_user_input
          result = @validation_client_creation.validate(new_client_name)
        end
        save_client(new_client_name)
      end

      private 

      def client_repo
        Repository.for(:client)
      end

      def save_client(new_client_name)
        client_repo.create(new_client_name)
        client_repo.save
      end
    end
  end
end
