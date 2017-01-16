module TimeLogger
  module Console
    class ClientCreation

      def initialize(console_ui, validation)
        @console_ui = console_ui
        @validation = validation
        @client_retrieval = TimeLogger::ClientRetrieval.new
      end

      def execute
        @console_ui.new_client_name_message

        new_client_name = @console_ui.get_user_input

        new_client_name = blank_client_name_loop(new_client_name)

        new_client_name = client_exists_loop(new_client_name)

        @client_retrieval.save_client(new_client_name)
      end

      private

      def blank_client_name_loop(client_name)
        while @validation.blank_space?(client_name)
          @console_ui.valid_client_name_message
          client_name = @console_ui.get_user_input
        end
        client_name
      end

      def client_exists_loop(client_name)
        while @client_retrieval.find_client(client_name)
          @console_ui.client_exists_message
          client_name = @console_ui.get_user_input
        end
        client_name
      end
    end
  end
end
