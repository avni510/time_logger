module SQL
  class ClientRepo
    
    def initialize(db_connection)
      @connection = db_connection
    end

    def create(client_name)
      @connection.exec(
        "INSERT INTO CLIENTS (name) values('#{client_name}')"
      )
    end

    def find_by(id)
      result = @connection.exec(
        "SELECT * FROM CLIENTS WHERE ID='#{id}'"
      )
      return nil if result.values.empty?
      client_list = result.values[0]
      create_client_object(client_list)
    end

    def find_by_name(name)
      result = @connection.exec(
        "SELECT * FROM CLIENTS WHERE name='#{name}'"
      )
      return nil if result.values.empty?
      client_list = result.values[0]
      create_client_object(client_list)
    end

    def all
      result = @connection.exec(
        "SELECT * FROM CLIENTS"
      )
      return nil if result.values.empty?
      result.values.map do |client_values|
        create_client_object(client_values)
      end
    end

    private 

    def create_client_object(values)
      id = values[0].to_i
      name = values[1]
      TimeLogger::Client.new(id, name)
    end
  end
end
