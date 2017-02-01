require "spec_helper"
module SQL
  describe ClientRepo do
    before(:each) do
      @connection = PG::Connection.open(:dbname => "time_logger_test")
      @client_repo = ClientRepo.new(@connection)
    end

    after(:each) do
      @connection.exec("DELETE FROM CLIENTS")
      @connection.exec(
        "ALTER SEQUENCE clients_id_seq RESTART WITH 1"
      )
      @connection.close if @connection
    end

    describe ".create" do
      it "creates a new client in the database" do
        client_name = "Google"
        @client_repo.create(client_name)
        result = @connection.exec("SELECT * FROM CLIENTS WHERE name='#{client_name}'")
        expect(result.values[0][1]).to eq("Google")
      end
    end

    describe ".find_by" do
      it "takes in a client id and returns an object with the corresponding id" do
        id = 1
        client_name = "Google"
        @client_repo.create(client_name)
        expected_client = TimeLogger::Client.new(id, "Google")
        result_client = @client_repo.find_by(id)
        expect(result_client.id).to eq(expected_client.id) 
      end

      it "returns nil if the id does not exist in the database" do
        nonexistent_id = 2
        @client_repo.create("Google")
        expect(@client_repo.find_by(nonexistent_id)).to eq(nil) 
      end
    end

    describe ".find_by_name" do
      context "the client name exists in the database" do
        it "returns a client object for a given client name" do
          client_name = "Google"
          @client_repo.create(client_name)
          expected_client = TimeLogger::Client.new(1, "Google")
          result_client = @client_repo.find_by_name("Google")
          expect(result_client.name).to eq(expected_client.name) 
        end
      end

      context "the client name does not exist in the database" do
        it "returns nil" do
          @client_repo.create("Google")
          nonexistent_client = "Microsoft"
          result_client = @client_repo.find_by_name(nonexistent_client)
          expect(result_client).to eq(nil) 
        end
      end
    end

    describe ".save" do
      it "passes all the clients that need to be saved" do
        @client_repo.save
      end
    end

    describe ".all" do
      it "returns an array of all client objects" do
        @client_repo.create("Google")
        @client_repo.create("Microsoft")
        expected_clients = [ 
          [TimeLogger::Client.new(1, "Google")],
          [TimeLogger::Client.new(2, "Microsoft")],
        ]
        result_clients = @client_repo.all
        expect(result_clients.count).to eq(2)
        expect(result_clients[0].name).to eq("Google")
      end
    end

    context "there are no clients in the database" do
      it "returns nil" do
        result_clients = @client_repo.all
        expect(result_clients).to eq(nil) 
      end
    end
  end
end
