module TimeLogger
  module Console
    class ClientCreation

      def initialize(console_ui, validation_client_creation)
        @console_ui = console_ui
        @validation_client_creation = validation_client_creation
        @client_retrieval = TimeLogger::ClientRetrieval.new
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

        @client_retrieval.save_client(new_client_name)
      end
    end
  end
end
