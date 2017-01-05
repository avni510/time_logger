module TimeLogger
  require "spec_helper"

  describe LogTimeRetrieval do

    before(:each) do
      @employee_id = 1
      @mock_log_time_repo = double
      @mock_client_repo = double
      allow(Repository).to receive(:for).with(:log_time).and_return(@mock_log_time_repo)
      allow(Repository).to receive(:for).with(:client).and_return(@mock_client_repo)
      @log_time_retrieval = LogTimeRetrieval.new
    end

    describe ".employee_hours_worked_for_date" do
      it "returns the total hours worked for a given employee on a given date" do
        previous_hours_worked = 0
        expect(@mock_log_time_repo).
          to receive(:find_total_hours_worked_for_date).
          with(@employee_id, "09-15-2016").
          and_return(previous_hours_worked)
        result = @log_time_retrieval.employee_hours_worked_for_date(@employee_id, "09-15-2016")
        expect(result).to eq(previous_hours_worked)
      end
    end

    describe ".all_clients" do
      it "returns all the clients in the repo" do
        clients = [
          Client.new(1, "Microsoft"),
          Client.new(2, "Facebook")
        ]
        expect(@mock_client_repo).
          to receive(:all).
          and_return(clients)
        result = @log_time_retrieval.all_clients
        expect(result).to eq(clients)
      end
    end

    describe ".save_log_time_entry" do
      it "creates an entry in the repo and persists the data" do
        employee_id = 1
        date = "09-15-2016"
        hours = "8"
        timecode = "Billable"
        client = "Microsoft"
        params = {
          "employee_id": employee_id,
          "date": Date.strptime(date, '%m-%d-%Y').to_s,
          "hours_worked": hours,
          "timecode": timecode, 
          "client": client
        }
        expect(@mock_log_time_repo).
          to receive(:create).
          with(params)
        expect(@mock_log_time_repo).
          to receive(:save)
        @log_time_retrieval.save_log_time_entry(employee_id, date, hours, timecode, client)
      end
    end
  end
end
