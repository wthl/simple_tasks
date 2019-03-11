print "Speed of train: "
Vt = gets.to_f

print "Speed of fly: "
Vf = gets.to_f

print "The distance between A & B: "
$distance = gets.to_f

$try = 0

while $distance > 0.000000001  do
	
	a = Vf + Vt
	t = $distance / a
	$distance = $distance - 2*t*Vt

	print "Try No: #{$try + 1} \t next distance: #{$distance} \n"
	
	$try += 1

end
