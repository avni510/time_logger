module TimeLogger
  require "spec_helper"
  
  describe Employee do
    
    before(:each) do 
      id = 1
      username = "gharrison"
      admin = false
      @employee = Employee.new(id, username, admin)
    end

    it "returns the id of an employee" do
      expect(@employee.id).to eq(1)
    end

    it "returns the username of an employee" do
      expect(@employee.username).to eq("gharrison")
    end

    it "returns either true of false if an employee is an admin" do
      expect(@employee.admin).to eq(false)
    end
  end
end
