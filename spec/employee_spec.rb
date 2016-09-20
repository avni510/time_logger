module TimeLogger
  require "spec_helper"
  output_file_name = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"
  
  describe Employee do

    it "creates a new Employee and saves it to a file" do
      file_wrapper = FileWrapper.new
      employee = Employee.new("avnikothari", file_wrapper, output_file_name)
      puts file_wrapper.read_data(output_file_name)

#      file_wrapper.write_data(output_file_name, {"username": "avnikothari"})
      #read file
      #expect(read file out put format).to eq( 
      #{ "workers": [
      #{
      # "username": "avnikothari"
      #]
      # { "clients": [] }
      
    end

    it "displays a menu of options for the user to choose from"do
    end

    it "allows the user to enter the date of when they want to log time for" do
    end

    it "allows the user to enter how many hours worked" do
    end

    it "allows the user to enter the type of work" do
    end


    it "doesn't allow the user to select a date in the future" do
    end

    it "doesn't allow the user to enter more than 24 hours" do
    end

  end
end
