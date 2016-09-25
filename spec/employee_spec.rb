module TimeLogger
  require "spec_helper"
  
  describe Employee do

    before(:each) do 
      @mock_save_data = double
      @employee = Employee.new("avnik", @mock_save_data)
    end

    describe ".create" do
      it "creates a new Employee" do
        expect(@mock_save_data).to receive(:add_username).with("avnik")
        @employee.create("avnik")
      end
    end
  end
end
