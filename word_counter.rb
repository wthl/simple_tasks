f = File.open 'file.txt', 'r'

@hh = {}

def add_to_hash word
  if !word.empty?
    word.downcase!

    cnt = @hh[word].to_i
    cnt += 1
    @hh[word] = cnt
  end
end

  f.each_line do |line|
    arr = line.split(/\s|\n|\.|,/)
    arr.each {|word| add_to_hash(word)}
  end

f.close

max = 0

@result = {}

@hh.each do |key, value|
  if value > max
    max = value
    @result[key] = value
    @hh.delete(key)
  end
end

@result.each do |key, value|
  puts "#{value} #{key}"
end