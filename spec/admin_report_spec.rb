module TimeLogger
  require "spec_helper" 

  describe AdminReport do

    before(:each) do
      @mock_console_ui = double 
      @admin_report = AdminReport.new(@mock_console_ui)

      @mock_log_time_repo = double
      allow(Repository).to receive(:for).and_return(@mock_log_time_repo)
    end

    describe ".execute" do
      context "there are timecodes and clients in memory " do
        it "returns a report of the current month of company wide timecode hours worked and client hours" do
          company_timecode_hash = 
            {
              "Billable" => 4, 
              "Non-Billable" => 6,
              "PTO" => 5
            }

          expect(@mock_log_time_repo).to receive(:company_timecode_hours).and_return(company_timecode_hash)

          company_client_hash =  
            { 
              "Microsoft" => 5,
              "Google" => 3
            }

          expect(@mock_log_time_repo).to receive(:company_client_hours).and_return(company_client_hash)

          expect(@mock_console_ui).to receive(:format_admin_report).with(company_timecode_hash, company_client_hash)

          @admin_report.execute
        end
      end

      context "there are no clients in memory but there are timecodes in memory" do
        it "returns a report of the timecodes and displays a message that there are no client hours" do
          company_timecode_hash = 
            {
              "Billable" => 4, 
              "Non-Billable" => 6,
              "PTO" => 5
            }

          expect(@mock_log_time_repo).to receive(:company_timecode_hours).and_return(company_timecode_hash)

          expect(@mock_log_time_repo).to receive(:company_client_hours).and_return(nil)

          expect(@mock_console_ui).to receive(:no_client_hours)

          @admin_report.execute
        end
      end

      context "there are no log entries with timecodes" do
        it "returns a message that there are no logged timecodes for the current month" do
          expect(@mock_log_time_repo).to receive(:company_timecode_hours).and_return(nil)

          expect(@mock_console_ui).to receive(:no_company_timecode_hours)

          @admin_report.execute
        end
      end
    end
  end
end
