module TimeLogger
  require "spec_helper"
  
  describe LogTimeEntry do

    before(:each) do
      entry_id  = 1
      employee_id = 1
      date = "09-08-2016"
      hours = "8"
      timecode = "Non-Billable"
      client = nil

      @log_time_entry = LogTimeEntry.new(entry_id, employee_id, date, hours, timecode, client)
    end

    it "has an id related to each entry of logging time" do
      expect(@log_time_entry.entry_id).to eq(1)
    end

    it "has an employee id related to each entry of logging time" do
      expect(@log_time_entry.employee_id).to eq(1)
    end

    it "has a date related to each entry of logging time" do
      expect(@log_time_entry.date).to eq("09-08-2016")
    end

    it "has a hours worked related to each entry of logging time" do
      expect(@log_time_entry.hours_worked).to eq("8")
    end

    it "has a timecode related to each entry of logging time" do
      expect(@log_time_entry.timecode).to eq("Non-Billable")
    end

    it "has a client related to each entry of logging time" do
      expect(@log_time_entry.client).to eq(nil)
    end
  end
end
