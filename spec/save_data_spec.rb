module TimeLogger
  require "spec_helper"
  output_file = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"

  describe SaveData do

    let(:file_wrapper) { FileWrapper.new }

    describe ".add_username" do
      it "adds the username to the JSON file" do
        
      data_hash = file_wrapper.read_data(output_file)
      original_data_hash = JSON.parse(JSON.generate(data_hash))

      save_data = SaveData.new(file_wrapper, output_file)

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

      file_wrapper.write_data(output_file, original_data_hash)
      end
    end

    describe ".add_date" do
      it "adds the date to the JSON file" do
        data_hash = file_wrapper.read_data(output_file)
        original_data_hash = JSON.parse(JSON.generate(data_hash))
        save_data = SaveData.new(file_wrapper, output_file)

        save_data.add_username("avnik")

        save_data.add_date("09-19-2016", "avnik")

        data = file_wrapper.read_data(output_file)
        
        expect(data).to include_json(
          "workers": [ 
            {
              username: "avnik", 
              admin: false, 
              log_time: [ {"date": "09-19-2016"} ]
            } ]
        )

        
        file_wrapper.write_data(output_file, original_data_hash)
      end
    end
  end
end
