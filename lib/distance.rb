module Reporting
  class Distance
    def initialize(from, to)
      @from = from
      @to = to
    end

    def percentage
      return comparison(:percentage)
    end

    def value
      return comparison(:value)
    end

    private
      def comparison(calculation)
        return Comparison.new(@from, @to, calculation)
      end

      class Comparison
        def initialize(from, to, calculation)
          @from = from 
          @to = to
          @calculation = calculation
        end

        def method_missing(name, *args)
          return "Unknown" unless ! (@from.nil? || @to.nil?)
          fval = @from.send(name)
          tval = @to.send(name)
          case @calculation
          when :percentage
            100.0 * ((tval - fval) / fval)
          when :value
            tval - fval
          else
            raise "UNKNOWN Comparison: #{@calculation}"
          end
        end         
      end
  end
end # module Reporting
