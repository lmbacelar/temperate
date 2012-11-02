When /^I read (.+) ohms on a standard rtd of type (.*)$/ do |r, t|
  @temperature = RTD.temperature(type: t.downcase.to_sym, resistance: r.to_f)
end

Then /^I should get a (.+) degrees Celsius temperature$/ do |t|
  @temperature.should == t.to_f
end
