module TimeLogger
  class Repository

    def self.repositories
      @repositories ||= {}
    end

    def self.register(type, repo)
      @repositories[type.to_sym] = repo
    end

    def self.for(type)
      @repositories[type.to_sym]
    end
  end
end
