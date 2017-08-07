# TO CALCULATE THE AVERAGE DISTANCE FROM CPPTRAJ OUTPUT FILE

set f [open "[lindex $::argv 0]" "r"]
set data [read $f]
close $f

set g [open "[lindex $::argv 1]" "w"]

set k 3

set mean 0.0
set nterms 0
while { $k < [llength $data] } {
	set mean [expr { $mean + [lindex $data $k] }]
	incr k 2
	incr nterms
}

if { $nterms > 0 } {
	set mean [expr { $mean / $nterms }]
}

# STANDARD DEVIATION

set k 3
set var 0.0
while { $k < [llength $data] } {
	set diff [expr { $mean - [lindex $data $k] }]
	set diff [expr { $diff * $diff }]
	set var [expr { $var + $diff }]
	incr k 2
}
set var [expr { $var / $nterms }]
set SD [expr { sqrt($var) }]

puts $g "	$mean ($SD) "
puts "	### MEAN = $mean Standard deviation = $SD ###"
close $g

