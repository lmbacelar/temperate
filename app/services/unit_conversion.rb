class UnitConversion < Struct.new(:quantity)
  QUANTITIES = { temperature: :conv_temperature }

  def convert(value, from, to, delta = false)
    self.send(QUANTITIES.fetch(quantity), value, from, to, delta)
  end

private
  TO_CELSIUS = { celsius:    [1    ,  0],
                 kelvin:     [1    , -273.15],
                 fahrenheit: [1/1.8, -32/1.8], 
                 rankine:    [1/1.8, -273.15] }

  def conv_temperature(t, from, to, delta)
    if from != :celsius
      factor = TO_CELSIUS.fetch(from)
      t = t * factor[0] + (delta ? 0 : factor[1])
    end
    raise RangeError if t < -273.1501
    if to != :celsius
      factor = TO_CELSIUS.fetch(to)
      t = (t - (delta ? 0 : factor[1])) / factor[0]
    end
    t
  end
end
