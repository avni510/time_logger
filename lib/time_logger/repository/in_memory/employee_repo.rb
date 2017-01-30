module InMemory
  class EmployeeRepo
    attr_reader :employees

    def initialize(save_json_data)
      @save_json_data = save_json_data
      @employees = []
    end

    def create(username, admin=false)
      employee_id = @employees.count + 1
      employee = TimeLogger::Employee.new(employee_id, username, admin)
      @employees << employee
    end

    def find_by(id)
      @employees.each do |employee|
        return employee if employee.id == id
      end
      nil
    end
    
    def find_by_username(username)
      @employees.each do |employee|
        return employee if employee.username == username
      end
      nil
    end

    def save
      @save_json_data.employees(@employees)
    end

    def all
      @employees
    end
  end
end
