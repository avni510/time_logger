module TimeLogger
  require "spec_helper"

  output_file_name = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"

  describe FileWrapper do

    let(:file_wrapper) { FileWrapper.new }

    it "reads and writes data to a json file" do

      data_hash = file_wrapper.read_data(output_file_name)
      original_data_hash = JSON.parse(JSON.generate(data_hash))

      username_hash = { 
        "id": 1, 
        "username": "rstarr", 
        "admin": false,
        "log_times": [] 
      }

      data_hash["workers"] << username_hash

      file_wrapper.write_data(output_file_name, data_hash)

      data = file_wrapper.read_data(output_file_name)

      expect(data).to include_json(
        "workers": [ 
          {
            id: 1,
            username: "rstarr",
            admin: false,
            log_times: []
          } ]
      )

      file_wrapper.write_data(output_file_name, original_data_hash)
    end
  end
end
