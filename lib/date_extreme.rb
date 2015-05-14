module Reporting
  # DateExtreme is the base class for fake datestamps that occurs before or after all other date values.
  class DateExtreme 
    def at_beginning_of_month
      return self
    end

    def at_end_of_month
      return self
    end

    def to_s # :nodoc:
      "<END OF DAYS>"
    end
  end

end # module Reporting
