module Util
def self.num_to_day(num)
  num  = num.to_i
  case num
  when 1
    return "sunday"
  when 2
    return "monday"
  when 3
    return "tuesday"
  when 4
    return "wednesday"
  when 5
    return "thursday"
  when 6
    return "friday"
  when 7
    return "saturday"
  end

  return nil  
end
end