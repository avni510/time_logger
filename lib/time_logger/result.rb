module TimeLogger
  class Result 
    attr_reader :errors
    def initialize(errors=nil)
      @errors = errors
    end
    
    def valid?
      @errors ? false : true
    end
  end
end
