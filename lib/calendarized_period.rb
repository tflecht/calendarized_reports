module Reporting
  class CalendarizedPeriod
    attr_reader :date_end, :date_start, :readings
    def initialize(date_start, date_end, readings)
      @date_end = date_end
      @date_start = date_start

      # Select the readings whose date range overlaps this period's date range (inclusive)
      @readings = readings.select { |r| (@date_start <= r.date_end) && (r.date_start <= @date_end) }
    end

    def coverage_percentage(meter)
      days_covered = 0
      readings_from_meter = @readings.select { |r| meter.readings.include?(r) }
      readings_from_meter.each { |r| days_covered += days_in_period(r) }
      (days_covered.to_f / (date_end - date_start + 1)) * 100
    end

    def covers(date)
      date.between?(@date_start, @date_end)
    end

    # deliberately not supporting arguments yet, since there is no legitimate message that readings
    # receive that takes arguments.
    def method_missing(method)
      result = 0.0
      return result unless (! @readings.empty?)
      relevant_readings = @readings.select { |r| r.respond_to?(method) }
      raise "No readings have any information on #{method}" if relevant_readings.empty?
      relevant_readings.each do |r|
        result += proration(r) * (r.send method)
      end
      result
    end

    def months
      return @months unless @months.nil?
      @months = []
      d = @date_start.at_beginning_of_month
      while d < @date_end
        @months << CalendarizedPeriod.new(d, d.at_end_of_month, @readings)
        d += 1.month
      end
      @months
    end

    def relative_to(period)
      return Reporting::Distance.new(period, self)
    end

    def to_s
      s = "Start Date: #{date_start}, End Date: #{date_end} (#{@readings.count})\n"
      @readings.each do |r|
        s+= "\t#{r}\n"
      end
      s
    end


    private
      def days_in_period(reading)
        (([reading.date_end, @date_end].min + 1) - [reading.date_start, @date_start].max)
      end

      def proration(reading)
        days_in_period(reading) / reading.days.to_f
      end

  end # class CalendarizedPeriod
end # module Reporting
