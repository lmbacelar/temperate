class IEC60751

  MAX_ITERATIONS = 50
  LLIMIT = -200.10
  ULIMIT =  850.10
                  
  def self.resistance(params={})
    parse params
    raise ArgumentError.new('t is required!') unless @@t
    res_celsius
  end

  def self.temperature(params={})
    parse params
    raise ArgumentError.new('r is required!') unless @@r
    Unit.convert(t: temp_celsius, from: :celsius, to: @@unit)
  end

private
  def self.parse(params={})
    @@r           = params[:r]
    @@t           = params[:t]
    @@unit        = params[:unit]        ||  :celsius
    @@max_error   = params[:max_error]   ||  0.0001
    @@r0          = params[:R0]          ||  100.0
    @@a           = params[:A]           ||  3.9083e-03
    @@b           = params[:B]           || -5.7750e-07
    @@c           = params[:C]           || -4.1830e-12

    @@tc          = Unit.convert(t: @@t, from: @@unit, to: :celsius) if @@t
  end

  def self.approximate_temperature
    if @@r >= @@r0
      (-@@a + (@@a**2 - 4 * @@b * (1 - @@r / @@r0))**(0.5)) / (2 * @@b)
    else
      ((@@r / @@r0) - 1) / (@@a + 100 * @@b)
    end
  end

  def self.res_celsius(params={})
    unless params[:skip_check]
      raise RangeError.new('t is out of range') if @@tc < LLIMIT || @@tc > ULIMIT
    end
    if @@tc < 0.00
      @@r0*(1 + @@a*@@tc + @@b*@@tc**2 + @@c*(@@tc - 100)*@@tc**3)
    else
      @@r0*(1 + @@a*@@tc + @@b*@@tc**2)
    end
  end

  def self.temp_celsius
    return 0.00 if @@r == @@r0
    @@tc = approximate_temperature
    MAX_ITERATIONS.times do
      s = (@@r - @@r0) / @@tc
      r = res_celsius(skip_check: true)
      if (r - @@r).abs < s * @@max_error
        raise RangeError.new('t is out of range') if (@@tc < LLIMIT || @@tc > ULIMIT)
        return @@tc
      end
      @@tc -= (r - @@r) / s
    end
    raise 'iteration on reverse function did not converge!'
  end
end

