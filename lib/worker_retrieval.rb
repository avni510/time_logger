module TimeLogger
  class WorkerRetrieval

    def run(username)
      employee_repo.find_by_username(username)
    end

    def company_employees
      employee_repo.all
    end

    private

    def employee_repo
      Repository.for("employee")
    end
  end
end
