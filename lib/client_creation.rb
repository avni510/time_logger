module TimeLogger
  class ClientCreation

    def initialize(console_ui)
      @console_ui = console_ui
    end

    def execute
      @console_ui.new_client_name_message

      new_client_name = @console_ui.get_user_input

      new_client_name = blank_client_name_loop(new_client_name)

      new_client_name = client_exists_loop(new_client_name)

      client_repo.create(new_client_name)
      client_repo.save
    end

    private

    def client_repo
      Repository.for(:client)
    end

    def blank_client_name_loop(client_name)
      until client_name !~ /^\s*$/ 
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
  end
end
