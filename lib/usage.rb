module Reporting
  class Usage
    def initialize(meters)
      @meters = meters
    end

    def all
      Reporting::MeterReadingSet.new @meters
    end

    def electricity
      Reporting::MeterReadingSet.new @meters.select { |m| m.instance_of? ElectricityMeter }
    end

    def energy
      Reporting::MeterReadingSet.new @meters.select { |m| (m.instance_of? ElectricityMeter) || (m.instance_of? NaturalGasMeter) }
    end

    def fossil_fuel
      # will eventually need to include heating oil
      Reporting::MeterReadingSet.new @meters.select { |m| m.instance_of? NaturalGasMeter }
    end

    def natural_gas
      Reporting::MeterReadingSet.new @meters.select { |m| m.instance_of? NaturalGasMeter }
    end

    def water
      # will also need sewer eventually, which is water billed differently
      Reporting::MeterReadingSet.new @meters.select { |m| m.instance_of? WaterMeter }
    end

  end # class Usage
end # module Reporting
