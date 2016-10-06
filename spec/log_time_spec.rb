module TimeLogger
  require 'spec_helper'

  describe LogTime do
    let(:mock_console_ui) { double }
    let(:validation) { Validation.new }

    let(:log_date) { LogDate.new(mock_console_ui, validation) }
    let(:log_hours_worked) { LogHoursWorked.new(mock_console_ui, validation) }
    let(:log_timecode) { LogTimecode.new(mock_console_ui, validation) }
    let(:log_client) { LogClient.new(mock_console_ui, validation) }

    let(:log_time) { LogTime.new(log_date, log_hours_worked, log_timecode, log_client) } 

    before(:each) do
      @employee_id = 1

      @mock_log_time_repo = double
      @mock_client_repo = double

      allow(Repository).to receive(:for).with(:log_time).and_return(@mock_log_time_repo)
      allow(Repository).to receive(:for).with(:client).and_return(@mock_client_repo)
    end

    before(:each) do
      allow(log_date).to receive(:run).and_return("09-15-2016")  

      previous_hours_worked = 0

      allow(@mock_log_time_repo).
        to receive(:find_total_hours_worked_for_date).
        with(@employee_id, "09-15-2016").
        and_return(previous_hours_worked)

      allow(log_hours_worked).to receive(:run).
        with(previous_hours_worked).
        and_return("5")
      

      allow(@mock_client_repo).
        to receive(:all).
        and_return(@clients)

      allow(log_timecode).to receive(:run).
        with(@clients).
        and_return("Non-Billable")

      allow(@mock_log_time_repo).to receive(:create)

      allow(@mock_log_time_repo).to receive(:save)
    end

    context "the user does not select 'Billable' as their timecode" do
      it "allows the user to log their time" do
        expect(log_date).to receive(:run).and_return("09-15-2016")  

        previous_hours_worked = 0

        expect(@mock_log_time_repo).
          to receive(:find_total_hours_worked_for_date).
          with(@employee_id, "09-15-2016").
          and_return(previous_hours_worked)

        expect(log_hours_worked).to receive(:run).
          with(previous_hours_worked).
          and_return("5")

        expect(@mock_client_repo).
          to receive(:all).
          and_return(@clients)

        expect(log_timecode).to receive(:run).
          with(@clients).
          and_return("Non-Billable")

        log_time.execute(@employee_id)
      end

      it "creates a new entry in the repository and saves it" do
        params = 
          { 
            "employee_id": @employee_id,
            "date": "2016-09-15", 
            "hours_worked": "5",
            "timecode": "Non-Billable", 
            "client": nil
          }

        expect(@mock_log_time_repo).to receive(:create).with(params)

        expect(@mock_log_time_repo).to receive(:save)

        log_time.execute(@employee_id)
      end
    end

    context "the user selects 'Billable' as their timecode" do
      it "makes a call to select a client and saves it" do
        expect(log_timecode).to receive(:run).
          with(@clients).
          and_return("Billable")

        expect(log_client).to receive(:run).
          with(@clients).
          and_return("Google")

        params = 
          { 
            "employee_id": @employee_id,
            "date": "2016-09-15", 
            "hours_worked": "5",
            "timecode": "Billable", 
            "client": "Google"
          }

        expect(@mock_log_time_repo).to receive(:create).with(params)

        expect(@mock_log_time_repo).to receive(:save)

        log_time.execute(@employee_id)
      end
    end

    context "hours_entered returns nil because a the user 
            has exceeded 24 hours for the date entered" do
      it "prompts the user to enter their date again" do
        allow(log_date).to receive(:run).and_return("09-15-2016", "09-16-2016")

        expect(@mock_log_time_repo).
          to receive(:find_total_hours_worked_for_date).
          and_return(20, 0)

        expect(log_hours_worked).to receive(:run).
          and_return(nil, "5")

        log_time.execute(@employee_id)
      end
    end
  end
end

