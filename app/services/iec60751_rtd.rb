require 'key_struct'
class Iec60751Rtd < KeyStruct[r0: 100.0, a: 3.9083e-03, b: -5.775e-07, c: -4.1830e-12]
  MAX_ITERATIONS =   50
  VALID_RANGE    = -200.10..850.10

  def resistance(t, unit = :celsius)
    res_celsius(UnitConversion.new(:temperature).convert(t, unit, :celsius))
  end

  def temperature(r, unit = :celsius)
    UnitConversion.new(:temperature).convert(temp_celsius(r), :celsius, unit)
  end

private
  def res_celsius(t_celsius, skip_check = false)
    raise RangeError unless skip_check || VALID_RANGE.include?(t_celsius)
    if t_celsius < 0.00
      r0*(1 + a*t_celsius + b*t_celsius**2 + c*(t_celsius - 100)*t_celsius**3)
    else
      r0*(1 + a*t_celsius + b*t_celsius**2)
    end
  end
  
  def temp_celsius(r, max_error = 0.0001)
    return 0.00 if r == r0
    t_calc = approximate_temperature(r)
    MAX_ITERATIONS.times do
      slope = (r - r0) / t_calc
      r_calc = res_celsius(t_calc, true)
      if (r_calc - r).abs < slope * max_error
        raise RangeError unless VALID_RANGE.include?(t_calc)
        return t_calc
      end
      t_calc -= (r_calc - r) / slope
    end
    raise 'iteration on reverse function did not converge!'
  end

  def approximate_temperature(r)
    if r >= r0
      (-a + (a**2 - 4 * b * (1 - r / r0))**(0.5)) / (2 * b)
    else
      ((r / r0) - 1) / (a + 100 * b)
    end
  end
end
