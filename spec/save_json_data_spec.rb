require "spec_helper"
module TimeLogger

  describe SaveJsonData do
    let(:output_file) { File.expand_path("data/" + "time_logger_data.json") }
    let(:file_wrapper) { FileWrapper.new(output_file) }
    let(:save_json_data) { SaveJsonData.new(file_wrapper) }

    def read_original_file_data
      data_hash = file_wrapper.read_data
      @original_data_hash = JSON.parse(JSON.generate(data_hash))
    end

    def setup_initial_test_data
      data_hash =  { "workers": [], "clients": [] }
      file_wrapper.write_data(data_hash)
    end

    def rewrite_original_file_data
      file_wrapper.write_data(@original_data_hash)
    end

    describe ".employees" do
      context "no users are in the JSON file" do
        it "adds all the employees to a JSON file" do
          read_original_file_data

          setup_initial_test_data

          employee_entry_1 = Employee.new(1, "gharrison", false)
          employee_entry_2 = Employee.new(2, "jlennon", false)

          employees = [ employee_entry_1, employee_entry_2 ]

          save_json_data.employees(employees)

          data = file_wrapper.read_data
          
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
          
          setup_initial_test_data

          data_hash = 

            {
            "workers": [{
              "id": 1,
              "username": "rstarr",
              "admin": false,
              "log_time": [
                {
                  "id": 1,
                  "date": "2016-09-07",
                  "hours_worked": "8",
                  "timecode": "Non-Billable",
                  "client": nil
                }, {
                  "id": 2,
                  "date": "2016-09-08",
                  "hours_worked": "8",
                  "timecode": "PTO",
                  "client": nil
                }]
            }],
            "clients": []
          }


          file_wrapper.write_data(data_hash)

          employee_entry_1 = Employee.new(1, "rstarr", false)
          employee_entry_2 = Employee.new(2, "gharrison", false)
          employee_entry_3 = Employee.new(3, "jlennon", false)

          employees = [ employee_entry_1, employee_entry_2, employee_entry_3 ]

          save_json_data.employees(employees)

          data = file_wrapper.read_data
          
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
                    date: "2016-09-07",
                    hours_worked: "8",
                    timecode: "Non-Billable",
                    client: nil
                  }, 
                  {
                    id: 2,
                    date: "2016-09-08",
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
      context "log entries do not exist in JSON" do
        it "adds all entries of log time to the JSON file" do
          read_original_file_data

          setup_initial_test_data
          
          employee_entry_1 = Employee.new(1, "rstarr", false)
          employees = [ employee_entry_1 ]

          save_json_data.employees(employees)

          params_entry_1 = 
            { 
              "id": 1, 
              "employee_id": 1, 
              "date": "2016-09-07", 
              "hours_worked": "8", 
              "timecode": "Non-Billable", 
              "client": nil 
            }
          params_entry_2 = 
            { 
              "id": 2, 
              "employee_id": 1, 
              "date": "2016-09-08", 
              "hours_worked": "8", 
              "timecode": "PTO", 
              "client": nil 
            }

          log_time_entry_1 = LogTimeEntry.new(params_entry_1)
          log_time_entry_2 = LogTimeEntry.new(params_entry_2)

          entries = [ log_time_entry_1, log_time_entry_2 ]

          save_json_data.log_time(entries)

          data = file_wrapper.read_data
          
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
                      "date": "2016-09-07",
                      "hours_worked": "8", 
                      "timecode": "Non-Billable",
                      "client": nil
                    },
                    {
                      "id": 2,
                      "date": "2016-09-08",
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
      end

      context "log data exists in the JSON" do
        it "adds the newly entered log time into the JSON" do
          read_original_file_data

          setup_initial_test_data

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
                  "date": "2016-09-07",
                  "hours_worked": "8",
                  "timecode": "Non-Billable",
                  "client": nil
                }, {
                  "id": 2,
                  "date": "2016-09-08",
                  "hours_worked": "8",
                  "timecode": "PTO",
                  "client": nil
                }]
            }],
            "clients": []
          }

          file_wrapper.write_data(data_hash)

          params_entry_1 = 
            { 
              "id": 1, 
              "employee_id": 1, 
              "date": "2016-09-07", 
              "hours_worked": "8", 
              "timecode": "Non-Billable", 
              "client": nil 
            }
          params_entry_2 = 
            { 
              "id": 2, 
              "employee_id": 1, 
              "date": "2016-09-08", 
              "hours_worked": "8", 
              "timecode": "PTO", 
              "client": nil 
            }

          params_entry_3 = 
            { 
              "id": 3, 
              "employee_id": 1, 
              "date": "2016-09-05", 
              "hours_worked": "8", 
              "timecode": "Non-Billable", 
              "client": nil 
            }

          log_time_entry_1 = LogTimeEntry.new(params_entry_1)
          log_time_entry_2 = LogTimeEntry.new(params_entry_2)
          log_time_entry_3 = LogTimeEntry.new(params_entry_3)

          entries = [ log_time_entry_1, log_time_entry_2, log_time_entry_3 ]

          save_json_data.log_time(entries)

          data = file_wrapper.read_data
          
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
                      "date": "2016-09-07",
                      "hours_worked": "8", 
                      "timecode": "Non-Billable",
                      "client": nil
                    },
                    {
                      "id": 2,
                      "date": "2016-09-08",
                      "hours_worked": "8", 
                      "timecode": "PTO",
                      "client": nil
                    },
                    {
                      "id": 3,
                      "date": "2016-09-05",
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

    describe ".clients" do
      it "adds the client data to a JSON file" do
        read_original_file_data

        setup_initial_test_data

        client_entry_1 = Client.new(1, "Google")
        client_entry_2 = Client.new(2, "Microsoft")

        clients = [ client_entry_1, client_entry_2 ]

        save_json_data.clients(clients)

        data = file_wrapper.read_data

        expect(data).to include_json(
          "clients":
          [
            {
              id: 1,
              name: "Google"
            },
            {
              id: 2,
              name: "Microsoft"
            }
          ])

        rewrite_original_file_data
      end
    end
  end
end
