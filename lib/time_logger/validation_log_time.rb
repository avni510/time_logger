module TimeLogger
  class ValidationLogTime

    def initialize(validation_date, validation_hours_worked, log_time_repo)
      @validation_date = validation_date
      @validation_hours_worked = validation_hours_worked
      @log_time_repo = log_time_repo
    end

    def validate(params)
      if params.has_key?(:date)
        result_date = @validation_date.validate(params[:date])
        return result_date unless result_date.valid?
      end
      if params.has_key?(:hours_worked)
        result_hours_worked = @validation_hours_worked.validate(params[:hours_worked]) 
        return result_hours_worked unless result_hours_worked.valid?
      end
      if params.has_key?(:hours_worked) && params.has_key?(:employee_id) && params[:date]
        previous_hours_worked = @log_time_repo.find_total_hours_worked_for_date(params[:employee_id], params[:date])
        result_hours_worked = @validation_hours_worked.validate(previous_hours_worked, params[:hours_worked])
        return result_hours_worked unless result_hours_worked.valid?
      end
      Result.new
    end
  end
end
