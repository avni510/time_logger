module TimeLogger
  require "spec_helper"

  describe SaveJsonData do
    let(:output_file) { "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json" }
    let(:file_wrapper) { FileWrapper.new }
    let(:save_json_data) { SaveJsonData.new(file_wrapper, output_file) }

    def read_original_file_data
      data_hash = file_wrapper.read_data(output_file)
      @original_data_hash = JSON.parse(JSON.generate(data_hash))
    end

    def rewrite_original_file_data
      file_wrapper.write_data(output_file, @original_data_hash)
    end

    describe ".employees" do
      context "no users are in the JSON file" do
        it "adds all the employees to a JSON file" do
          read_original_file_data

          employee_entry_1 = Employee.new(1, "gharrison", false)
          employee_entry_2 = Employee.new(2, "jlennon", false)

          employees = [ employee_entry_1, employee_entry_2 ]

          save_json_data.employees(employees)

          data = file_wrapper.read_data(output_file)
          
          expect(data).to include_json(
            "workers": 
            [ 
              {
                id: 1,
                username: "gharrison", 
                admin: false, 
                log_time: []
              },
              {
                id: 2,
                username: "jlennon", 
                admin: false, 
                log_time: []
              } 
            ]
          )


          rewrite_original_file_data
        end
      end

      context "users exist in the JSON" do
        it "adds all the employees to a JSON file" do
          read_original_file_data
          
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

          file_wrapper.write_data(output_file, data_hash)

          employee_entry_1 = Employee.new(1, "rstarr", false)
          employee_entry_2 = Employee.new(2, "gharrison", false)
          employee_entry_3 = Employee.new(3, "jlennon", false)

          employees = [ employee_entry_1, employee_entry_2, employee_entry_3 ]

          save_json_data.employees(employees)

          data = file_wrapper.read_data(output_file)
          
          expect(data).to include_json(
            "workers": 
            [ 
              {
                id: 1,
                username: "rstarr",
                admin: false,
                log_time: [
                  {
                    id: 1,
                    date: "09-07-2016",
                    hours_worked: "8",
                    timecode: "Non-Billable",
                    client: nil
                  }, 
                  {
                    id: 2,
                    date: "09-08-2016",
                    hours_worked: "8",
                    timecode: "PTO",
                    client: nil
                  }]
              },
              {
                id: 2,
                username: "gharrison", 
                admin: false, 
                log_time: []
              },
              {
                id: 3,
                username: "jlennon", 
                admin: false, 
                log_time: []
              } 
            ]
          )


          rewrite_original_file_data
        end
      end
    end


    describe ".log_time" do
      it "adds all entries of log time to the JSON file" do
        read_original_file_data

        
        employee_entry_1 = Employee.new(1, "rstarr", false)
        employees = [ employee_entry_1 ]

        save_json_data.employees(employees)

        log_time_entry_1 = LogTimeEntry.new(1, 1, "09-07-2016", "8", "Non-Billable", nil)
        log_time_entry_2 = LogTimeEntry.new(2, 1, "09-08-2016", "8", "PTO", nil)

        entries = [ log_time_entry_1, log_time_entry_2 ]

        save_json_data.log_time(entries)

        data = file_wrapper.read_data(output_file)
        
        expect(data).to include_json(
          "workers": 
          [ 
            {
              id: 1,
              username: "rstarr", 
              admin: false, 
              log_time: 
                [ 
                  {
                    "id": 1,
                    "date": "09-07-2016",
                    "hours_worked": "8", 
                    "timecode": "Non-Billable",
                    "client": nil
                  },
                  {
                    "id": 2,
                    "date": "09-08-2016",
                    "hours_worked": "8", 
                    "timecode": "PTO",
                    "client": nil
                  }
                ]
            } 
          ]
        )
        rewrite_original_file_data
      end

      context "log data exists in the JSON" do
        it "adds the newly entered log time into the JSON" do
          read_original_file_data

          employee_entry_1 = Employee.new(1, "rstarr", false)
          employees = [ employee_entry_1 ]

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

          file_wrapper.write_data(output_file, data_hash)

          log_time_entry_1 = LogTimeEntry.new(1, 1, "09-07-2016", "8", "Non-Billable", nil)
          log_time_entry_2 = LogTimeEntry.new(2, 1, "09-08-2016", "8", "PTO", nil)

          log_time_entry_3 = LogTimeEntry.new(3, 1, "09-05-2016", "8", "Non-Billable", nil)
          entries = [ log_time_entry_1, log_time_entry_2, log_time_entry_3 ]

          save_json_data.log_time(entries)

          data = file_wrapper.read_data(output_file)
          
          expect(data).to include_json(
            "workers": 
            [ 
              {
                id: 1,
                username: "rstarr", 
                admin: false, 
                log_time: 
                  [ 
                    {
                      "id": 1,
                      "date": "09-07-2016",
                      "hours_worked": "8", 
                      "timecode": "Non-Billable",
                      "client": nil
                    },
                    {
                      "id": 2,
                      "date": "09-08-2016",
                      "hours_worked": "8", 
                      "timecode": "PTO",
                      "client": nil
                    },
                    {
                      "id": 3,
                      "date": "09-05-2016",
                      "hours_worked": "8", 
                      "timecode": "Non-Billable",
                      "client": nil
                    },
                  ]
              } 
            ]
          )

          rewrite_original_file_data
        end
      end
    end
  end
end