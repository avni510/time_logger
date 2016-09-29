module TimeLogger
  require "spec_helper"

  describe ConsoleRunner do
#    before(:each) do
#      @mock_console_ui = double 
#      @validation = Validation.new 
#      @file_name = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"
#      @mock_log_time_repo =  double 
#      @file_wrapper = FileWrapper.new 
#      @mock_log_time_repo = double 
#      @mock_employee_repo = double
#      repositories_hash = {
#        "log_time": @mock_log_time_repo,
#        "employee": @mock_employee_repo
#      }
#      @repository = Repository.new(repositories_hash) 
#      @console_runner = ConsoleRunner.new(@mock_console_ui, @mock_save_json_data, @validation, @file_name, @file_wrapper, @repository)
#    end
#
#    def read_original_file_data
#      data_hash = @file_wrapper.read_data(@file_name)
#      @original_data_hash = JSON.parse(JSON.generate(data_hash))
#    end
#
#    def rewrite_original_file_data
#      @file_wrapper.write_data(@file_name, @original_data_hash)
#    end
#
#
#    describe ".run" do
#      context "data exists in the JSON" do
#        it "prompts the user to enter their username" do

#          read_original_file_data
#
#          data_hash = 
#
#            {
#            "workers": [{
#              "id": 1,
#              "username": "rstarr",
#              "admin": false,
#              "log_time": [
#                {
#                  "id": 1,
#                  "date": "09-07-2016",
#                  "hours_worked": "8",
#                  "timecode": "Non-Billable",
#                  "client": nil
#                }, {
#                  "id": 2,
#                  "date": "09-08-2016",
#                  "hours_worked": "8",
#                  "timecode": "PTO",
#                  "client": nil
#                }]
#            }],
#            "clients": []
#          }
#
#          @file_wrapper.write_data(@file_name, data_hash)

#          expect(@mock_log_time_repo).to receive(:create).with(1, "09-07-2016", "8", "Non-Billable", nil)
#
#          expect(@mock_log_time_repo).to receive(:create).with(1, "09-08-2016", "8", "PTO", nil)
#
#          expect(@mock_employee_repo).to receive(:create).with(1,"rstarr", false)
#
#          expect(@mock_console_ui).to receive(:username_display_message)
#          expect(@mock_console_ui).to receive(:get_user_input).and_return("rstarr")
#
#          allow_any_instance_of(MenuSelection).to receive(:menu_messages)
#          @console_runner.run
#
#          rewrite_original_file_data
#        end
#      end
#    end
  end
end
