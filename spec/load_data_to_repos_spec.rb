require "spec_helper"
module TimeLogger

  describe LoadDataToRepos do
    let(:mock_file_wrapper) { double } 
    let(:mock_save_json_data) { double }
    let(:load_data_to_repos) { LoadDataToRepos.new(mock_file_wrapper, mock_save_json_data) }

    def setup_with_data
      data_hash = 
        {
          "workers": [{
            "id": 1,
            "username": "rstarr",
            "admin": false,
            "log_time": [
              {
                "id": 1,
                "date": "09-07-2016",
                "hours_worked": "8",
                "timecode": "Non-Billable",
                "client": nil
              }, {
                "id": 2,
                "date": "09-08-2016",
                "hours_worked": "8",
                "timecode": "PTO",
                "client": nil
              }]
          }],
          "clients": [
            {
              "id": 1, 
              "name": "Google"
            },
            { 
              "id": 2, 
              "name": "Microsoft"
            }
          ]
        }

      JSON.parse(JSON.generate(data_hash))
    end

    describe ".run" do
      it "loads data from a file" do
        data_hash = setup_with_data
        expect(mock_file_wrapper).to receive(:read_data).and_return(data_hash)
        expect_any_instance_of(InMemory::EmployeeRepo).
          to receive(:create).exactly(1).times
        expect_any_instance_of(InMemory::LogTimeRepo).
          to receive(:create).exactly(2).times
        expect_any_instance_of(InMemory::ClientRepo).
          to receive(:create).exactly(2).times
        expect(Repository).to receive(:register).exactly(3).times
        load_data_to_repos.run
      end
    end
  end
end
