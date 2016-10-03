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

    def find_by(id)
      @entries.each do |entry|
        return entry if entry.id == id
      end
      nil
    end

    def find_by_employee_id(employee_id)
      filtered_entries = @entries.select do |entry|
        entry.employee_id == employee_id 
      end
      
      entries_empty?(filtered_entries)
    end

    def find_total_hours_worked_for_date(employee_id, date_string)
      total_hours_worked = 0

      entries_by_date = find_by_employee_id_and_date(employee_id, date_string)
      return total_hours_worked unless entries_by_date

      entries_by_date.each do |entry|
        total_hours_worked += entry.hours_worked
      end

      total_hours_worked
    end
  
    def find_by_employee_id_and_date(employee_id, date_string)
      date = Date.strptime(date_string,'%m-%d-%Y')
      filtered_entries = @entries.select { |entry| 
        entry.employee_id == employee_id && (entry.date.day == date.day && entry.date.month == date.month && entry.date.year == date.year)
      }

      entries_empty?(filtered_entries)
    end

    def save
      @save_json_data.log_time(@entries)
    end

    def all
      @entries
    end


    def sorted_current_month_entries_by_employee_id(employee_id)
      entries_by_employee = find_by_employee_id(1)

      return nil unless entries_by_employee

      current_month_entries = filter_for_current_month(entries_by_employee)
      sorted_entries = sort_log_times_by_date(current_month_entries)

      entries_empty?(sorted_entries)
    end

    def client_hours_for_current_month(employee_id)
      sorted_entries = sorted_current_month_entries_by_employee_id(employee_id)

      entries_with_clients = filter_entries_with_clients(sorted_entries)

      create_clients_hash(entries_with_clients)
    end

    def timecode_hours_for_current_month(employee_id)
      sorted_entries = sorted_current_month_entries_by_employee_id(employee_id)

      create_timecode_hash(sorted_entries)
    end

    private 

    def generate_log_entry_hash(log_entry_id, params)
      {
        "id": log_entry_id,
        "employee_id": params[:employee_id], 
        "date": Date.strptime(params[:date],'%m-%d-%Y'),
        "hours_worked": params[:hours_worked].to_i, 
        "timecode": params[:timecode], 
        "client": params[:client]
      }
    end

    def filter_entries_with_clients(entries)
      entries.reject { |log_time| log_time.client.nil? }
    end

    def create_clients_hash(entries)
      clients_hash = {}

      entries.each do |log_time|
        client = log_time.client
        if clients_hash.include?(client)
          clients_hash[client] += log_time.hours_worked
        else
          clients_hash[client] = log_time.hours_worked
        end
      end

      clients_hash
    end

    def create_timecode_hash(entries)
      timecode_hash = {}

      entries.each do |log_time|
        timecode = log_time.timecode
        if timecode_hash.include?(timecode)
          timecode_hash[timecode] += log_time.hours_worked
        else
          timecode_hash[timecode] = log_time.hours_worked
        end
      end

      timecode_hash
    end

    def client_attribute(log_time)
      log_time.client
    end

#    def populate_hash(attribute, entries)
#      
#      item_hash = {}
#
#      entries.each do |log_time|
##        if attribute == "client"
##          attribute = client_attribute(log_time)
##        end
#        client_attribute(log_time)
#
#        if item_hash.include?(attribute)
#          item_hash[attribute] += log_time_hours_worked
#        else
#          item_hash[attribute] = log_time_hours_worked
#        end
#      end
#     
#      item_hash
#    end

    def entries_empty?(entries)
      entries.empty? ? nil : entries
    end

    def sort_log_times_by_date(entries)
      entries.sort_by do |log_time_entry|
        log_time_entry.date
      end
    end

    def filter_for_current_month(entries)
      today = Date.today
      entries.reject do |log_time|
        log_time.date.month < today.month ||
        log_time.date.year < today.year 
      end
    end
  end
end

