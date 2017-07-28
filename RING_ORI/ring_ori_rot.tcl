# ORIENTATION OF THE PHYTOL RING
package require math::linearalgebra

set resid 13419

set start 1
set end 827
set step 5

# REFERENCE

# EXECUTING CPPTRAJ 

set f [open "input" "w"]

puts $f "trajin molf.inpcrd"
puts $f "strip !:$resid"
puts $f "trajout frame.pdb"
puts $f "go"

close $f

exec cpptraj -p molf_HMR.prmtop -i input

set g [open "frame.pdb" "r"]
set data [read $g]
close $g

set k 0
set i 0
while { $k < [llength $data] } {

	if { [lindex $data $k] == "O1" || [lindex $data $k] == "O2" } {
		set x1 [lindex $data [expr { $k + 3 }]]
		set sx1 [string length $x1]

		if { $sx1 > 8 } {
			set t 0
			while { [string range $x1 $t $t] != "." } {
				incr t
			}
			set xc1($i) [string range $x1 0 [expr { $t + 3 }]]
			set yc1($i) [string range $x1 [expr { $t + 4 }] end]
			set zc1($i) [lindex $data [expr { $k + 4 }]]
		} else { 
			set xc1($i) $x1
			set y1 [lindex $data [expr { $k + 4 }]]
			set sy1 [string length $y1]
			if { $sy1 > 8 } {
				set t 0
				while { [string range $y1 $t $t] != "." } {
					incr t
				}
				set yc1($i) [string range $y1 0 [expr { $t + 3 }]]
				set zc1($i) [string range $y1 [expr { $t + 4 }] end]
			} else {
				set yc1($i) [lindex $data [expr { $k + 4 }]]
				set zc1($i) [lindex $data [expr { $k + 5 }]]
			}
		}
		incr i
	}
	incr k 
}

# DETERMING THE NORMAL OF THE REFERENCE

set vec1 [list $xc1(0) $yc1(0) $zc1(0)]
set vec2 [list $xc1(1) $yc1(1) $zc1(1)]

set vec12 [::math::linearalgebra::sub $vec1 $vec2]
set vec12_REF [::math::linearalgebra::unitLengthVector $vec12]

set h [open "ring_ori_ROTATION" "w"]

for {set j $start} {$j < $end} {incr j $step} {

	puts "				#### FRAME $j ####"

	# EXECUTING CPPTRAJ 

	set f [open "input" "w"]

	puts $f "trajin prod1_w.nc $j $j"
	puts $f "strip !:$resid"
	puts $f "trajout frame.pdb"
	puts $f "go"

	close $f

	exec cpptraj -p molf_HMR.prmtop -i input

	set g [open "frame.pdb" "r"]
	set data [read $g]
	close $g

	set k 0
	set i 0
	while { $k < [llength $data] } {

		if { [lindex $data $k] == "O1" || [lindex $data $k] == "O2" } {
			set x1 [lindex $data [expr { $k + 3 }]]
			set sx1 [string length $x1]

			if { $sx1 > 8 } {
				set t 0
				while { [string range $x1 $t $t] != "." } {
					incr t
				}
				set xc1($i) [string range $x1 0 [expr { $t + 3 }]]
				set yc1($i) [string range $x1 [expr { $t + 4 }] end]
				set zc1($i) [lindex $data [expr { $k + 4 }]]
			} else { 
				set xc1($i) $x1
				set y1 [lindex $data [expr { $k + 4 }]]
				set sy1 [string length $y1]
				if { $sy1 > 8 } {
					set t 0
					while { [string range $y1 $t $t] != "." } {
						incr t
					}
					set yc1($i) [string range $y1 0 [expr { $t + 3 }]]
					set zc1($i) [string range $y1 [expr { $t + 4 }] end]
				} else {
					set yc1($i) [lindex $data [expr { $k + 4 }]]
					set zc1($i) [lindex $data [expr { $k + 5 }]]
				}
			}
			incr i
		}
		incr k 
	}

	# DETERMING THE NORMAL

	set vec1 [list $xc1(0) $yc1(0) $zc1(0)]
	set vec2 [list $xc1(1) $yc1(1) $zc1(1)]

	set vec12 [::math::linearalgebra::sub $vec1 $vec2]
	set vec12 [::math::linearalgebra::unitLengthVector $vec12]

	set angle [::math::linearalgebra::dotproduct $vec12 $vec12_REF]

	set angle [expr { acos($angle) }]

	set angle [expr { ($angle * 180.0) / 3.14 }]

	puts $h "$j $angle"
	puts "				$angle"
}
close $h

