# ALL TEMPERATURES IN CELSIUS
#
class Iec60751
  MAX_ITERATIONS =   50
  VALID_RANGE    = -200.10..850.10

  def self.res(t, r0 = 100.0, a = 3.9083e-3, b = -5.7750e-07, c = -4.1830e-12, skip_check = false)
    raise RangeError unless skip_check || VALID_RANGE.include?(t)
    if t < 0.00
      r0*(1 + a*t + b*t**2 + c*(t - 100)*t**3)
    else
      r0*(1 + a*t + b*t**2)
    end
  end
  
  def self.t90(r, r0 = 100.0, a = 3.9083e-3, b = -5.7750e-07, c = -4.1830e-12, max_error = 0.0001)
    return 0.00 if r == r0
    t_calc = approximate_t90(r, r0, a, b, c)
    MAX_ITERATIONS.times do
      slope = (r - r0) / t_calc
      r_calc = res(t_calc, r0, a, b, c, true)
      if (r_calc - r).abs < slope * max_error
        raise RangeError unless VALID_RANGE.include?(t_calc)
        return t_calc
      end
      t_calc -= (r_calc - r) / slope
    end
    raise StopIteration
  end

private
  def self.approximate_t90(r, r0, a, b, c)
    if r >= r0
      (-a + (a**2 - 4 * b * (1 - r / r0))**(0.5)) / (2 * b)
    else
      ((r / r0) - 1) / (a + 100 * b)
    end
  end
end
