module TimeLogger
  class WorkerRetrieval

    def run(username)
      employee_repo.find_by_username(username)
    end

    private

    def employee_repo
      Repository.for("employee")
    end
  end
end
