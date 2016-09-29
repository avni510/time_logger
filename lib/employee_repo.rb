module TimeLogger
  class EmployeeRepo
    attr_reader :employees

    def initialize(save_json_data)
      @save_json_data = save_json_data
      @employees = []
    end

    def create(username, admin=false)
      employee_id = @employees.count
      employee = Employee.new(employee_id, username, admin)
      @employees << employee
    end

    def find_by(username)
      @employees.each do |employee|
        return employee if employee.username == username
      end
    end

    def save
      @save_json_data.employees(@employees)
    end
  end
end
