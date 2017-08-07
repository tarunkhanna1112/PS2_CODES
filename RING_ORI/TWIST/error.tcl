set f [open "[lindex $::argv 0]" "r"]
set data [read $f]
close $f

set g [open "[lindex $::argv 1]" "w"]

set k 0

# DETERMING THE MEAN ORIENTATION OF THE RING WITH RESPECT TO THE REFERENCE VECTOR

set sum 0.0
set j 0
set k 1
while { $k < [llength $data] } {
	set t1 [lindex $data $k]
	set t2 [lindex $data [expr { $k + 1 }]]

	set sum [expr { $sum + $t1 + $t2 }]

	incr j 2
	incr k 3
}

set mean [expr {$sum / $j }]

# STANDARD DEVIATION

set k 1
set sd 0.0
while {$k < [llength $data] } {
	set t1 [lindex $data $k]
	set t2 [lindex $data [expr { $k + 1 }]]

	set diff [expr { $t1 - $mean }]
	set diff [expr { $diff * $diff }]

	set sd [expr { $sd + $diff }]

	set diff [expr { $t2 - $mean }]
	set diff [expr { $diff * $diff }]

	set sd [expr { $sd + $diff }]

	incr k 3	
}
set sd [expr { $sd / $j }]
set sd [expr { sqrt($sd) }]

puts "			#### MEAN EQUALS $mean WITH THE STANDARD DEVIATION OF $sd ####"
puts $g "$mean $sd"
