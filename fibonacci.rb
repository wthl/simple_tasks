print 'Enter first number of Fibonacci sequence (0 or 1): '

x = gets.to_i

if x == 1 || x == 0

  a = [x, 1]

  998.times { |i| a.push a.last(2).sum }

  puts "Thousandth number in this sequence would be #{a.last}"

else

  puts 'First number should be either 0 or 1'

end
