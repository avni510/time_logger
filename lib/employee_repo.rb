module TimeLogger
  class EmployeeRepo
    attr_reader :employees

    def initialize(save_json_data)
      @save_json_data = save_json_data
      @employees = []
    end

    def create(username, admin=false)
      if @employees.empty?
        employee_id = 1
      else
        employee_id = @employees.count += 1
      end

      employee = Employee.new(employee_id, username, admin)
      @employees << employee
    end

    def find_by(username)
      @employees.each do |employee|
        if employee.username == username
          return employee
        end
      end
    end

    def save
      @save_json_data.employees(@employees)
    end
  end
end
