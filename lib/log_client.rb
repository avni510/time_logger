module TimeLogger
  class LogClient

    def initialize(console_ui, validation)
      @console_ui = console_ui
      @validation = validation
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
        clients_hash[client.id] = "#{client.id}. #{client.name}"
      end
      clients_hash
    end

    def valid_client_loop(clients_hash, user_client_selection)
      until clients_hash.has_key?(user_client_selection.to_i)
        @console_ui.invalid_client_selection_message
        user_client_selection = @console_ui.get_user_input
      end
      user_client_selection
    end

    def client_selection_num_to_name(clients_hash, user_client_selection)
      client = clients_hash[user_client_selection.to_i]
      client = client[3..-1]
    end
  end
end
