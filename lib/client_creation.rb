module TimeLogger
  class ClientCreation

    def initialize(console_ui)
      @console_ui = console_ui
    end

    def execute
      @console_ui.new_client_name_message

      new_client_name = @console_ui.get_user_input

      until new_client_name !~ /^\s*$/ 
        @console_ui.valid_client_name_message
        new_client_name = @console_ui.get_user_input
      end

      while client_repo.find_by_name(new_client_name)
        @console_ui.client_exists_message
        new_client_name = @console_ui.get_user_input
      end
      
      client_repo.create(new_client_name)
      client_repo.save
    end

    private

    def client_repo
      Repository.for(:client)
    end
  end
end
