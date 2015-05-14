require 'singleton'
require 'reporting/date_extreme'

module Reporting
  # EndOfDays is a fake datestamp that occurs _after_ all other date values.
  class EndOfDays < DateExtreme
    include Comparable
    include Singleton

    ##
    # The EndOfDays always comes after +other+!

    def <=>(other)
      1
    end

    def to_s # :nodoc:
      "<END OF DAYS>"
    end
  end

  END_OF_DAYS = EndOfDays.instance
end # module Reporting
