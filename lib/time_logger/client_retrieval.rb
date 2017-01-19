module TimeLogger
  class ClientRetrieval

    def find_client(client_name)
      client_repo.find_by_name(client_name)
    end

    def find_all
      client_repo.all
    end

    def save_client(new_client_name)
      client_repo.create(new_client_name)
      client_repo.save
    end

    private 

    def client_repo
      Repository.for(:client)
    end
  end
end
