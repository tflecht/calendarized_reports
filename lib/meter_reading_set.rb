module Reporting
  class MeterReadingSet
    # MeterReadingSet allows access to calendarized representations of the aggregate reading data for a specified date range.
    def initialize(meters)
      @readings = []
      @date_earliest = Reporting::END_OF_DAYS
      @date_latest = Reporting::DAWN_OF_TIME

      meters.each { |m| @readings += m.readings }
  
      @readings.each do |r|
        @date_earliest = (@date_earliest < r.date_start ? @date_earliest : r.date_start.at_beginning_of_month)
        @date_latest = (@date_latest > r.date_end ? @date_latest: r.date_end.at_end_of_month)
      end
    end

    def month(date)
      # Return a calendarized period one month long for the month containing date.
      date = date.at_beginning_of_month
      CalendarizedPeriod.new(date, date.at_end_of_month, @readings)
    end

    def months(options={})
      calendarization_series(1, options)
    end

    def year(date)
      # Return a calendarized period twelve months long starting with the month containing date.
      date = date.at_beginning_of_month
      CalendarizedPeriod.new(date, date + 1.year - 1.day, @readings)
    end

    def years(options={})
      calendarization_series(12, options)
    end

    private
      def calendarization_series(months_per_period, options)
        date_start = (options[:date_start] || @date_earliest).at_beginning_of_month
        date_end = (options[:date_end] || @date_latest).at_end_of_month
        
        readings = @readings.select { |r| ((r.date_start <= date_end) && (r.date_end >= date_start))  }

        CalendarizedPeriodSeries.new(months_per_period, date_start, date_end, readings)
      end

  end # class MeterReadingSet
end # module Reporting
