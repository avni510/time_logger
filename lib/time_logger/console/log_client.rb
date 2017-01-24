module TimeLogger
  module Console
    class LogClient

      def initialize(console_ui, validation_menu)
        @console_ui = console_ui
        @validation_menu = validation_menu
      end

      def run(clients)
        clients_hash = generate_clients_hash(clients)

        @console_ui.display_menu_options(clients_hash)

        user_client_selection = @console_ui.get_user_input

        user_client_selection = valid_client_loop(clients_hash, user_client_selection)

        client_selection_num_to_name(clients_hash, user_client_selection)
      end

      private

      def generate_clients_hash(client_objects)
        clients_hash = {}
        client_objects.each do |client|
          clients_hash[client.id.to_s] = "#{client.id}. #{client.name}"
        end
        clients_hash
      end

      def valid_client_loop(clients_hash, user_client_selection)
        result = @validation_menu.validate(clients_hash, user_client_selection)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          user_client_selection = @console_ui.get_user_input
          result = @validation_menu.validate(clients_hash, user_client_selection)
        end
        user_client_selection
      end

      def client_selection_num_to_name(clients_hash, user_client_selection)
        client = clients_hash[user_client_selection.to_s]
        client = client[3..-1]
      end
    end
  end
end
