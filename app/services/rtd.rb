class Rtd
  TYPES = { iec60751: 'Iec60751Rtd',
            sprt:     'Sprt' }

  def self.temperature(args)
    type = args.delete(:type) { raise ArgumentError }
    r    = args.delete(:r)    { raise ArgumentError }
    eval(TYPES[type]).new(args).temperature(r)
  end
end
