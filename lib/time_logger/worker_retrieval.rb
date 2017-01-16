module TimeLogger
  class WorkerRetrieval

    def employee(username)
      employee_repo.find_by_username(username)
    end

    def company_employees
      employee_repo.all
    end

    def save_employee(username, admin_authority)
      employee_repo.create(username, admin_authority)
      employee_repo.save
    end 

    private

    def employee_repo
      Repository.for("employee")
    end
  end
end
