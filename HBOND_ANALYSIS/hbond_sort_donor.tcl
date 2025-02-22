set frac_limit [lindex $::argv 1]
set offset [lindex $::argv 2]
set data [list [lindex $::argv 0]]

set g [open "avghb.dat" "r"]
set data1 [read $g]
close $g

set h [open "hbond_sel" "w"]

puts $h "# AcceptorID	AcceptorNAME	donorID	donorNAME	fraction	avg_dist	avg_angle"

set k 7

while { $k < [llength $data1] } {
	set ac [lindex $data1 $k]

	set acn [string range $ac 0 2]
	set t 0
	while { [string range $ac $t $t] != "@" } {
		incr t
	}
	set aci [string range $ac 4 [expr { $t - 1 }]]

	set do [lindex $data1 [expr { $k + 1 }]]

	set sdo [string length $do]
	
	set sldoi [expr { $sdo - 7 }]

	set ledo [expr { 3 + $sldoi }]

	set don [string range $do 0 2]
	
	set t 0
	while { [string range $do $t $t] != "@" } {
		incr t
	}
	set doi [string range $do 4 [expr { $t - 1 }]]


	set frac [lindex $data1 [expr { $k + 4 }]]
	set avg_dist [lindex $data1 [expr { $k + 5 }]]
	set avg_angle [lindex $data1 [expr { $k + 6 }]]

	set k1 0

	while { $k1 < [llength $data] } {
		set cri [lindex $data $k1]

		if { $doi == $cri && $frac >= $frac_limit } {
			puts $h "$aci	$acn	$doi	$don	$frac $avg_dist $avg_angle"
		}
		incr k1
	}

	incr k 7
}
close $h

set h1 [open "hbond_sel" "r"]
set data2 [read $h1]
close $h1

set h2 [open "sorted_hbond_sel" "w"]

set k 10
set i 0
while { $k < [llength $data2] } {
	set l 0
	set col1($i) [lindex $data2 $k]

	set count 0
	for {set j 0} {$j < $i} {incr j} {
		if { $col1($j) == $col1($i) } {
			incr count
		}
	}

	if { $count == 0 } {

		puts $h2 "$col1($i)	[lindex $data2 [expr { $k + 1 }]]"

		set k1 10

		while { $k1 < [llength $data2] } {
			set ccol1 [lindex $data2 $k1]

			if { $ccol1 == $col1($i) } {
				set col3($l) [lindex $data2 [expr { $k1 - 2 }]]
				
				set count 0
				for {set j 0 } {$j < $l} {incr j} {
					if { $col3($j) == $col3($l) } {
						incr count
					}
				}

				if { $count == 0 } {

					set col4 [lindex $data2 [expr { $k1 - 1 }]]
					set col5 [lindex $data2 [expr { $k1 + 2 }]]
					set col6 [lindex $data2 [expr { $k1 + 3 }]]
					set col7 [lindex $data2 [expr { $k1 + 4 }]]

					set pdbid [expr { $col3($l) - $offset }]

					puts $h2 "	$col3($l)	$col4	$col5	$col6	$col7"
					incr l
				}
			}
			incr k1 7
		}
		incr i
	}
	
	incr k 7
}
			


















