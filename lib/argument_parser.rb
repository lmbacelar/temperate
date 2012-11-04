module ArgumentParser
  def parse!(args, options={})
    Array(options[:required]).each { |arg| raise ArgumentError.new("#{arg} is required") unless args[arg] }
    args = options[:default].merge(args) if options[:default]
  end

  def parse(args, options={})
    parse!(args.dup)
  end
end

