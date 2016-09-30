module TimeLogger
  require "spec_helper"

  describe ClientRepo do
    let(:mock_save_json_data) { double }
    let(:client_repo) { ClientRepo.new(mock_save_json_data) } 

    it "returns a list of clients" do
      expect(client_repo.clients).to eq([])
    end

    before(:each) do
      @name = "Google"
    end

    describe ".create" do
      it "creates a new client object and add it to the list of clients" do
        client_repo.create(@name)

        result = client_repo.clients

        expect(result[0]).to be_a_kind_of(Client)
      end
    end

    describe ".find_by" do
      context "the client name exists in memory" do
        it "returns a client object for a given client name" do
          client_repo.create(@name)

          result = client_repo.find_by(@name)

          expect(result.name).to eq("Google")
        end
      end

      context "the client name does not exist in memory" do
        it "returns nil" do
          client_repo.create(@name)

          result = client_repo.find_by("Microsoft")

          expect(result).to eq(nil)
        end
      end
    end

    describe ".save" do
      it "passes all the clients that need to be saved" do
        client_repo.create(@name)

        clients = client_repo.clients

        expect(mock_save_json_data).to receive(:clients).with(clients)

        client_repo.save
      end
    end
  end
end
