When /^I read (.+) ohms on a rtd of type (.*)$/ do |r, t|
  @temperature = RTD.temperature(type: t.downcase.to_sym, r: r.to_f)
end

Then /^I should get a (.+) degrees Celsius temperature$/ do |t|
  @temperature.should == t.to_f
end
