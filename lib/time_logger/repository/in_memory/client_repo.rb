module InMemory
  class ClientRepo
    attr_reader :clients
    
    def initialize(json_store)
      @store = json_store
    end

    def clients
      clients_array = @store.data["clients"]
      clients_array.map do |client|
        TimeLogger::Client.new(
          client["id"],
          client["name"]
        )
      end
    end

    def create(name)
      client_id = clients.count + 1
      data_hash = {
        "id": client_id,
        "name": name
      }
      data_hash = JSON.parse(JSON.generate(data_hash))
      @store.data["clients"] << data_hash
    end

    def find_by(id)
      clients.find { |client| client.id == id }
    end

    def find_by_name(name)
      clients.find { |client| client.name == name }
    end

    def all
      clients
    end
  end
end
