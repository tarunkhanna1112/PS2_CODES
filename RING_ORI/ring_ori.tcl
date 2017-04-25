# ORIENTATION OF THE PHYTOL RING
package require math::linearalgebra

set resid 6667

set start 1
set end 1700
set step 15

# REFERENCE

# EXECUTING CPPTRAJ 

set f [open "input" "w"]

puts $f "trajin molf.inpcrd"
puts $f "strip !:$resid"
puts $f "trajout frame.pdb"
puts $f "go"

close $f

exec cpptraj -p molf.prmtop -i input

set g [open "frame.pdb" "r"]
set data [read $g]
close $g

set k 0
set i 0
while { $k < [llength $data] } {

	if { [lindex $data $k] == "C1" || [lindex $data $k] == "C2" || [lindex $data $k] == "C3" } {
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
set vec3 [list $xc1(2) $yc1(2) $zc1(2)]

set vec12 [::math::linearalgebra::sub $vec1 $vec2]
set vec12 [::math::linearalgebra::unitLengthVector $vec12]
set vec32 [::math::linearalgebra::sub $vec3 $vec2]
set vec32 [::math::linearalgebra::unitLengthVector $vec32]

set refnorm [::math::linearalgebra::crossproduct $vec32 $vec12]
set refnorm [::math::linearalgebra::unitLengthVector $refnorm]

set h [open "ring_ori" "w"]

for {set j $start} {$j < $end} {incr j $step} {

	puts "				#### FRAME $j ####"

	# EXECUTING CPPTRAJ 

	set f [open "input" "w"]

	puts $f "trajin prod1_w.nc $j $j"
	puts $f "strip !:$resid"
	puts $f "trajout frame.pdb"
	puts $f "go"

	close $f

	exec cpptraj -p molf.prmtop -i input

	set g [open "frame.pdb" "r"]
	set data [read $g]
	close $g

	set k 0
	set i 0
	while { $k < [llength $data] } {

		if { [lindex $data $k] == "C1" || [lindex $data $k] == "C2" || [lindex $data $k] == "C3" || [lindex $data $k] == "C4" || [lindex $data $k] == "C5" || [lindex $data $k] == "C6"} {
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
	set vec3 [list $xc1(2) $yc1(2) $zc1(2)]
	set vec4 [list $xc1(3) $yc1(3) $zc1(3)]
	set vec5 [list $xc1(4) $yc1(4) $zc1(4)]
	set vec6 [list $xc1(5) $yc1(5) $zc1(5)]

	set vec12 [::math::linearalgebra::sub $vec1 $vec2]
	set vec12 [::math::linearalgebra::unitLengthVector $vec12]
	set vec32 [::math::linearalgebra::sub $vec3 $vec2]
	set vec32 [::math::linearalgebra::unitLengthVector $vec32]
	set vec45 [::math::linearalgebra::sub $vec4 $vec5]
	set vec45 [::math::linearalgebra::unitLengthVector $vec45]
	set vec65 [::math::linearalgebra::sub $vec6 $vec5]
	set vec65 [::math::linearalgebra::unitLengthVector $vec65]

	set norm [::math::linearalgebra::crossproduct $vec32 $vec12]
	set norm [::math::linearalgebra::unitLengthVector $norm]

	set norm1 [::math::linearalgebra::crossproduct $vec65 $vec45]
	set norm1 [::math::linearalgebra::unitLengthVector $norm1]

	set angle [::math::linearalgebra::dotproduct $refnorm $norm]

	set angle [expr { acos($angle) }]

	set angle [expr { ($angle * 180.0) / 3.14 }]

	set angle1 [::math::linearalgebra::dotproduct $refnorm $norm1]

	set angle1 [expr { acos($angle1) }]

	set angle1 [expr { ($angle1 * 180.0) / 3.14 }]

	puts $h "$j $angle $angle1"
	puts "				$angle $angle1"
}
close $h

