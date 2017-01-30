require "spec_helper"
module InMemory

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

        expect(result[0].name).to eq("Google")
      end
    end

    describe ".find_by" do
      it "takes in a client id and returns an object with the corresponding id" do
        client_repo.create(@name)

        result = client_repo.find_by(1)

        expect(result.id).to eq(1)
        expect(result.name).to eq("Google")
      end

      it "returns nil if the id does not exist in memory" do
        result = client_repo.find_by(2)

        expect(result).to eq(nil)
      end
    end

    describe ".find_by_name" do
      context "the client name exists in memory" do
        it "returns a client object for a given client name" do
          client_repo.create(@name)

          result = client_repo.find_by_name(@name)

          expect(result.name).to eq("Google")
        end
      end

      context "the client name does not exist in memory" do
        it "returns nil" do
          client_repo.create(@name)

          result = client_repo.find_by_name("Microsoft")

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

    describe ".all" do
      it "returns an array of all client objects" do
        client_repo.create(@name)
        client_repo.create("Microsoft")
        client_repo.create("Facebook")

        result = client_repo.all

        expect(result.count).to eq(3)
        expect(result[1].name).to eq("Microsoft")
      end
    end
  end
end
