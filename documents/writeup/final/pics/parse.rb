stat = File.read 'number_stats.txt'
numbers = []
stats.each_line{|line| line =~ /just numbers.*?_at(\d+\.\d+|\d+)/; number << $1 $1 }
puts numbers.inspect
