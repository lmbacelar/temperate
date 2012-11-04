class Unit
  def self.convert(args = {})
    parse! args
    t, from, to, delta = args[:t], args[:from], args[:to], args[:delta]

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
    case from
    when :celsius    then [1    ,  0]
    when :kelvin     then [1    , -273.15]
    when :fahrenheit then [1/1.8, -32/1.8]
    when :rankine    then [1/1.8, -273.15]
    else raise ArgumentError.new('unexpected unit!')
    end
  end

  def self.parse!(args)
    # check for missing required args
    [:t, :from, :to].each { |arg| raise ArgumentError.new("#{arg} is required") unless args[arg] }
    # default values
    args = { delta: false }.merge(args)
  end
end
