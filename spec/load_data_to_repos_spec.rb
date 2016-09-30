module TimeLogger
  require "spec_helper"

  describe LoadDataToRepos do
    let(:mock_file_wrapper) { double } 
    let(:mock_save_json_data) { double }
    let(:load_data_to_repos) { LoadDataToRepos.new(mock_file_wrapper, mock_save_json_data) }

    def setup_data
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
        "clients": []
      }

      JSON.parse(JSON.generate(data_hash))
    end

    describe ".run" do
      it "loads data from a file" do
        data_hash = setup_data

        expect(mock_file_wrapper).to receive(:read_data).and_return(data_hash)
        
        expect_any_instance_of(EmployeeRepo).to receive(:create).exactly(1).times

        expect_any_instance_of(LogTimeRepo).to receive(:create).exactly(2).times
        
        expect(load_data_to_repos.run).to be_a_kind_of(Repository)
      end
    end
  end
end
