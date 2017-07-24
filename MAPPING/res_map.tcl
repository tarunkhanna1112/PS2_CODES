# THIS SCRIPT RESTURN THE CORRESPODING RESIDURE IN FILE 1 AS COMPARED TO FILE 2

# FILE 1

set f [open "[lindex $::argv 0]" "r"]
set data [read $f]
close $f

set g [open "[lindex $::argv 1]" "r"]
set data1 [read $g]
close $g

set nchains [llength $data1]

puts "ENTER THE CHAIN NUMBER (1 to $nchains)"
set inp1 [gets stdin]
set inp1 [expr { $inp1 - 1}]
puts ""

set nres [llength [lindex $data1 $inp1]]
puts "ENTER THE RESIDUE NUMBER ([lindex $data1 $inp1 0] to [lindex $data1 $inp1 [expr { $nres - 1 }] ])"
set inp2 [gets stdin]
puts ""

set k 0
set count 0
while { $k  < [llength [lindex $data1 $inp1]] } {
	if  { [lindex $data1 $inp1 $k] == $inp2 } {
		incr count
		set pos $k
	}
	incr k
}

if { $count != 0 } {
	puts " CORRESPONDING TO RESIDUE $inp2 THERE IS [lindex $data $inp1 $pos] RESIDUE IN FILE 1"
} else {
	puts "	RESIDUE $inp2 NOT FOUND IN FILE 1"
}
