# ALL TEMPERATURES IN CELSIUS
#
class Iec60751
  MAX_ITERATIONS =   50
  VALID_RANGE    = -200.10..850.10

  def self.resistance(rtd, t, skip_check = false)
    raise RangeError unless skip_check || VALID_RANGE.include?(t)
    if t < 0.00
      rtd.r0*(1 + rtd.a*t + rtd.b*t**2 + rtd.c*(t - 100)*t**3)
    else
      rtd.r0*(1 + rtd.a*t + rtd.b*t**2)
    end
  end
  
  def self.temperature(rtd, r, max_error = 0.0001)
    return 0.00 if r == rtd.r0
    t_calc = approximate_temperature(rtd, r)
    MAX_ITERATIONS.times do
      slope = (r - rtd.r0) / t_calc
      r_calc = resistance(rtd, t_calc, true)
      if (r_calc - r).abs < slope * max_error
        raise RangeError unless VALID_RANGE.include?(t_calc)
        return t_calc
      end
      t_calc -= (r_calc - r) / slope
    end
    raise StopIteration
  end

  def self.approximate_temperature(rtd, r)
    if r >= rtd.r0
      (-rtd.a + (rtd.a**2 - 4 * rtd.b * (1 - r / rtd.r0))**(0.5)) / (2 * rtd.b)
    else
      ((r / rtd.r0) - 1) / (rtd.a + 100 * rtd.b)
    end
  end
end
