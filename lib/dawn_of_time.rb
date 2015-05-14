require 'singleton'
require 'reporting/date_extreme'

module Reporting
  # DawnOfTime is a fake datestamp that occurs _before_ all other date values.
  class DawnOfTime < DateExtreme
    include Comparable
    include Singleton

    ##
    # The DawnOfTime always comes before +other+!

    def <=>(other)
      -1
    end

    def to_s # :nodoc:
      "<DAWN OF TIME>"
    end
  end

  DAWN_OF_TIME = DawnOfTime.instance
end # module Reporting
