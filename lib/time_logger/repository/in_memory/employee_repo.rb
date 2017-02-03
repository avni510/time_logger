module InMemory
  class EmployeeRepo

    def initialize(employees_array)
      @data = employees_array
    end

    def employees
      @data.map do |employee| 
        TimeLogger::Employee.new(
          employee[:id], 
          employee[:username], 
          employee[:admin]
        )
      end
    end

    def create(username, admin=false)
      employee_id = employees.count + 1
      @data <<  
        {
          "id": employee_id,
          "username": username,
          "admin": admin,
          "log_time": []
        }
    end

    def find_by(id)
      employees.find { |employee| employee.id == id }
    end
    
    def find_by_username(username)
      employees.find { |employee| employee.username == username }
    end

    def save
#      @save_json_data.employees(@employees)
    end

    def all
      employees
    end
  end
end
