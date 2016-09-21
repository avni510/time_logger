module TimeLogger
  require "spec_helper"

  describe SaveData do
    let(:output_file) { "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json" }
    let(:file_wrapper) { FileWrapper.new }
    let(:save_data) { SaveData.new(file_wrapper, output_file) }

    def read_original_file_data
      data_hash = file_wrapper.read_data(output_file)
      @original_data_hash = JSON.parse(JSON.generate(data_hash))
    end

    def rewrite_original_file_data
      file_wrapper.write_data(output_file, @original_data_hash)
    end

    describe ".add_username" do
      it "adds the username to the JSON file" do
      read_original_file_data
        
      save_data.add_username("avnik")

      data = file_wrapper.read_data(output_file)

      expect(data).to include_json(
        "workers": [ 
          {
            username: "avnik", 
            admin: false, 
            log_time: []
          } ]
      )

      rewrite_original_file_data
      end
    end

    describe ".add_log_time" do
      it "adds the date to the JSON file" do
        read_original_file_data

        save_data.add_username("avnik")

        save_data.add_log_time("avnik", "09-19-2016", "6", "Billable")

        data = file_wrapper.read_data(output_file)
        
        expect(data).to include_json(
          "workers": [ 
            {
              username: "avnik", 
              admin: false, 
              log_time: [ 
                {
                  "date": "09-19-2016",
                  "hours_worked": "6", 
                  "timecode": "Billable"
                } ]
            } ]
        )
        
        rewrite_original_file_data
      end
    end
  end
end
