require "spec_helper"
module InMemory
  describe JsonStore do

    describe ".load" do
      it "loads the data from the file" do
        file_name = File.expand_path("data/" + "time_logger_data.json")
        file_wrapper = FileWrapper.new(file_name)
        json_store = JsonStore.new(file_wrapper)
        expect(json_store.load).to include_json(
            "employees": 
            [ 
              {
                id: 1,
                username: "defaultadmin", 
                admin: true, 
                log_time: []
              }
            ],
            "clients": []
          )
      end
    end
  end
end
