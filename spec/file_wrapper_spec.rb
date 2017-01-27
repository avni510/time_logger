module TimeLogger
  require "spec_helper"

  output_file_name = File.expand_path("data/" + "time_logger_data.json")

  describe FileWrapper do

    let(:file_wrapper) { FileWrapper.new(output_file_name) }

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

    it "reads and writes data to a json file" do
      read_original_file_data

      setup_initial_test_data

      data_hash = file_wrapper.read_data
      original_data_hash = JSON.parse(JSON.generate(data_hash))

      username_hash = { 
        "id": 1, 
        "username": "rstarr", 
        "admin": false,
        "log_times": [] 
      }

      data_hash["workers"] << username_hash

      file_wrapper.write_data(data_hash)

      data = file_wrapper.read_data

      expect(data).to include_json(
        "workers": [ 
          {
            id: 1,
            username: "rstarr",
            admin: false,
            log_times: []
          } ]
      )

      file_wrapper.write_data(original_data_hash)

      rewrite_original_file_data
    end
  end
end
