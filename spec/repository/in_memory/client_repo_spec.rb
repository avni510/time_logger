require "spec_helper"
module InMemory

  describe ClientRepo do
    before(:each) do
      @file_wrapper = double
      @json_store = JsonStore.new(@file_wrapper)
      data = 
        {
          "employees": 
          [
            {
              "id": 1,
              "username": "defaultadmin",
              "admin": true,
              "log_time": [
                {
                  "id": 1,
                  "date": "2017-01-01",
                  "hours_worked": 1,
                  "timecode": "Non-Billable",
                  "client": nil
                }
              ]
            },
            {
              "id": 2,
              "username": "rstarr",
              "admin": false,
              "log_time": [
                {
                  "id": 2,
                  "date": "2017-01-02",
                  "hours_worked": 1,
                  "timecode": "Non-Billable",
                  "client": nil
                }
              ]
            }
          ],
          "clients": [
            {
              "id": 1,
              "name": "Microsoft"
            }
          ]
        }
      data = JSON.parse(JSON.generate(data))
      expect(@file_wrapper).to receive(:read_data).and_return(data)
      @json_store.load
      @client_repo = ClientRepo.new(@json_store)
      @name = "Google"
    end

    describe ".clients" do
      it "returns an array of client objects from the data array" do
        expected_array = 
          [ 
            TimeLogger::Client.new(1, "Microsoft")
          ]
        result_array = @client_repo.clients
        expect(result_array[0].id).to eq(expected_array[0].id)
        expect(result_array[0].name).to eq(expected_array[0].name)
      end
    end

    describe ".create" do
      it "creates a new client and adds it to the data store" do
        @client_repo.create(@name)
        result = @client_repo.clients
        expect(result[1].name).to eq("Google")
      end
    end

    describe ".find_by" do
      it "takes in a client id and returns an object with the corresponding id" do
        result = @client_repo.find_by(1)
        expect(result.id).to eq(1)
        expect(result.name).to eq("Microsoft")
      end

      it "returns nil if the id does not exist in memory" do
        result = @client_repo.find_by(2)
        expect(result).to eq(nil)
      end
    end

    describe ".find_by_name" do
      context "the client name exists in memory" do
        it "returns a client object for a given client name" do
          @client_repo.create(@name)
          result = @client_repo.find_by_name(@name)
          expect(result.name).to eq("Google")
        end
      end

      context "the client name does not exist in memory" do
        it "returns nil" do
          result = @client_repo.find_by_name("Google")
          expect(result).to eq(nil)
        end
      end
    end

    describe ".all" do
      it "returns an array of all client objects" do
        @client_repo.create(@name)
        result = @client_repo.all
        expect(result.count).to eq(2)
        expect(result[0].name).to eq("Microsoft")
        expect(result[1].name).to eq("Google")
      end
    end
  end
end
