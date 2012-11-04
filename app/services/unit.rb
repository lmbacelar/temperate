class Unit
  def self.convert(params)
    t     = params[:t]
    from  = params[:from]
    to    = params[:to]
    delta = params[:delta] || false
    raise ArgumentError.new('t is required')    unless t
    raise ArgumentError.new('to is required')   unless to
    raise ArgumentError.new('from is required') unless from
    from  = from.downcase.to_sym
    to    = to.downcase.to_sym

    if from != :celsius
      factor = to_celsius(from)
      t = t * factor[0] + (delta ? 0 : factor[1])
    end
    raise RangeError.new('t is out of range') if t < -273.1501
    if to != :celsius
      factor = to_celsius(to)
      t = (t - (delta ? 0 : factor[1])) / factor[0]
    end
    t
  end

private
  def self.to_celsius(from)
    case from.downcase.to_sym
    when :celsius    then [1    ,  0]
    when :kelvin     then [1    , -273.15]
    when :fahrenheit then [1/1.8, -32/1.8]
    when :rankine    then [1/1.8, -273.15]
    else raise ArgumentError.new('unexpected unit!')
    end
  end
end
