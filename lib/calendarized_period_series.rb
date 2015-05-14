module Reporting
  class CalendarizedPeriodSeries
    extend Forwardable
    include Enumerable

    attr_accessor :month_end, :month_start
    def_delegators :@periods, :[], :each, :empty?, :first, :last, :map, :second

    def initialize(months_per_period, month_start, month_end, readings)
      @month_end = month_end # 'cast' to end of month?
      @month_start = month_start # 'cast' to beginning of month?
      @months_per_period = months_per_period
      @periods = []
      generate_periods(readings)
    end

    def period_for(date)
      # return the calendarization period the supplied date falls within
      @periods.each do |p|
        if p.covers(date)
          return p
        end
      end
      raise "supplied date wasn't within the range covered by the calendarization period series"
    end

    private
      def generate_periods(readings)
        month = @month_start
        while month < @month_end
          start = month
          month += @months_per_period.months 
          @periods << Reporting::CalendarizedPeriod.new(start, month - 1.day, readings)
        end
      end
  end # class CalendarizedPeriedSeries
end # module Reporting
