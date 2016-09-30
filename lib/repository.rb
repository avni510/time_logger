module TimeLogger
  class Repository

    def initialize(repositories_hash)
      @repositories = repositories_hash
    end

    def for(type)
      @repositories[type.to_sym]
    end
  end
end
