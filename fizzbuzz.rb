1.upto(100) do |i|
  
  if i == 0
    puts i
  elsif i % 3 == 0 && i % 5 == 0
    puts "#{i} FizzBuzz"
  elsif i % 3 == 0
    puts "#{i} Fizz"
  elsif i % 5 == 0
    puts "#{i} Buzz"
  else 
    puts i
  end
  
end