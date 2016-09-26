module TimeLogger
  class LogTimeEntry
    attr_reader :entry_id
    attr_reader :employee_id
    attr_reader :date
    attr_reader :hours_worked
    attr_reader :timecode
    attr_reader :client

    def initialize(entry_id, employee_id, date, hours_worked, timecode, client=nil)
      @entry_id = entry_id
      @employee_id = employee_id
      @date = date
      @hours_worked = hours_worked
      @timecode = timecode
      @client = client
    end
  end
end
