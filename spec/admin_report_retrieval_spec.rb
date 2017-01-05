module TimeLogger
  require "spec_helper"

  describe AdminReportRetrieval do

    before(:each) do
      @mock_log_time_repo = double
      allow(Repository).to receive(:for).and_return(@mock_log_time_repo)
      @admin_report_retrieval = AdminReportRetrieval.new
    end

    describe ".timecode_hours" do
      it "returns a hash of total hours worked per timecode" do
        company_timecode_hash = 
          {
            "Billable" => 4, 
            "Non-Billable" => 6,
            "PTO" => 5
          }
        expect(@mock_log_time_repo).
          to receive(:company_timecode_hours).
          and_return(company_timecode_hash)
        result = @admin_report_retrieval.timecode_hours
        expect(result).to eq(company_timecode_hash)
      end
    end

    describe ".client_hours" do
      it "returns a hash of total hours worked per client" do
        company_client_hash =  
          { 
            "Microsoft" => 5,
            "Google" => 3
          }
        expect(@mock_log_time_repo).
          to receive(:company_client_hours).
          and_return(company_client_hash)
        result = @admin_report_retrieval.client_hours
        expect(result).to eq(company_client_hash)
      end
    end
  end
end
