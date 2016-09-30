module TimeLogger
  class LogTimeRepo
    attr_reader :entries

    def initialize(save_json_data)
      @save_json_data = save_json_data
      @entries = []
    end


    def create(params)
      log_entry_id = @entries.count + 1

      log_entry_params = generate_log_entry_hash(log_entry_id, params)

      log_time_entry = LogTimeEntry.new(log_entry_params)

      @entries << log_time_entry
    end

    def find_by(employee_id, date=nil)
      if date == nil
        find_entries_for_employee_by(employee_id)
      else
        find_entries_for_date_by(employee_id, date)
      end
    end

    def save
      @save_json_data.log_time(@entries)
    end

    private 

    def generate_log_entry_hash(log_entry_id, params)
      {
        "id": log_entry_id,
        "employee_id": params[:employee_id], 
        "date": params[:date], 
        "hours_worked": params[:hours_worked], 
        "timecode": params[:timecode], 
        "client": params[:client]
      }
    end

    def find_entries_for_date_by(employee_id, date)
      filtered_entries = @entries.select { |entry| 
        entry.employee_id == employee_id && entry.date == date 
      }

      entries_empty?(filtered_entries)
    end

    def find_entries_for_employee_by(employee_id)
      filtered_entries = @entries.select { 
        |entry| entry.employee_id == employee_id 
      }
      
      entries_empty?(filtered_entries)
    end

    def entries_empty?(entries)
      entries.empty? ? nil : entries
    end
  end
end

