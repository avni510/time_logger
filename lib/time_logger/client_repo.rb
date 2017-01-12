module TimeLogger
  class ClientRepo
    attr_reader :clients
    
    def initialize(save_json_data)
      @save_json_data = save_json_data
      @clients = []
    end

    def create(name)
      client_id = @clients.count + 1
      client = Client.new(client_id, name)
      @clients << client
    end

    def find_by(id)
      @clients.each do |client|
        return client if client.id == id
      end
      nil
    end

    def find_by_name(name)
      @clients.each do |client|
        return client if client.name == name
      end
      nil
    end

    def save
      @save_json_data.clients(@clients)
    end

    def all
      @clients
    end
  end
end
