module TimeLogger
  class RepositoryRegistry

    def self.setup(params)
      Repository.repositories
      Repository.register("log_time", params[:log_time_repo])
      Repository.register("employee", params[:employee_repo])
      Repository.register("client", params[:client_repo])
    end
  end
end
