module TimeLogger
  require "spec_helper"

  describe RetrieveData do

    let(:file_name) { "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json" }
    let(:file_wrapper) { FileWrapper.new }
    let(:retrieve_data) { RetrieveData.new(file_wrapper, file_name) }
    let(:save_data) { SaveData.new(file_wrapper,file_name) }

    def read_original_file_data
      data_hash = file_wrapper.read_data(file_name)
      @original_data_hash = JSON.parse(JSON.generate(data_hash))
    end

    def rewrite_original_file_data
      file_wrapper.write_data(file_name, @original_data_hash)
    end

    describe ".user_log_times" do
      context "given a username" do
        it "returns an array of log times" do
          read_original_file_data

          save_data.add_username("kothari1")
          
          save_data.add_log_time("kothari1", "09-06-2016", "6", "Non-Billable")

          save_data.add_log_time("kothari1", "09-08-2016", "5", "PTO")

          save_data.add_log_time("kothari1", "09-07-2016", "10", "Billable", "Google")

          log_times = [
            {
              "date": "09-06-2016",
              "hours_worked": "6", 
              "timecode": "Non-Billable",
              "client": nil
            },
            {
              "date": "09-08-2016",
              "hours_worked": "5", 
              "timecode": "PTO",
              "client": nil
            },
            {
              "date": "09-07-2016",
              "hours_worked": "10", 
              "timecode": "Billable",
              "client": "Google"
            },
          ]

          log_times = JSON.parse(JSON.generate(log_times))

          expect(retrieve_data.user_log_times("kothari1")).to eq(log_times)

          rewrite_original_file_data
        end
      end
    end
  end
end
