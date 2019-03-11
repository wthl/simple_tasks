y = 0

x = 1

puts "Enter a number of addends "

count = gets.to_i

fib = 0
 
2.upto(count + 1) do |n|

    fib = y + x

    y = x

    x = fib

    n +=1

    print "#{fib} \t"

end