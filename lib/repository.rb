module TimeLogger
  class Repository

    def initialize(repositories_hash)
      @repositories = repositories_hash
    end

    def for(type)
      @repositories[type]
    end
  end
end
