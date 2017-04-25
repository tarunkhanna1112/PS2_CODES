set f [open "branch" "r"]
set data [read $f]
close $f

set g [open "path" "w"]

set res0 6667
set p 1

set k 2

while { [lindex $data [expr { $k + 1 }]] != "BRANCH2" } {
	set t1 [lindex $data $k]
	set t2 [lindex $data [expr { $k + 1 }]]

	set f1 [open "$t1.$t2" "r"]
	set data1 [read $f1]
	close $f1

	set res1 [lindex $data1 0]

	set k1 0

	while { [lindex $data $k1] != "BRANCH2" } {
		incr k1
	}

	incr k1

	while { [lindex $data [expr { $k1 + 1 }]] != "BRANCH3" } {

		if { [lindex $data $k1] == $t1 && [lindex $data [expr { $k1 + 1 }]] == $t2 } { 
			set t3 [lindex $data [expr { $k1 + 2 }]]

			set f2 [open "$t1.$t2.$t3" "r"]
			set data2 [read $f2]
			close $f2

			set res2 [lindex $data2 0]

			set k2 0

			while { [lindex $data $k2] != "BRANCH3" } {
				incr k2
			}

			incr k2

			while { [lindex $data [expr { $k2 + 1 }]] != "BRANCH4" } {

				if { [lindex $data $k2] == $t1 && [lindex $data [expr { $k2 + 1 }]] == $t2 && [lindex $data [expr { $k2 + 2 }]] == $t3 } {
					set t4 [lindex $data [expr { $k2 + 3 }]] 

					set f3 [open "$t1.$t2.$t3.$t4" "r"]
					set data3 [read $f3]
					close $f3

					set res3 [lindex $data3 0]

					set k3 0

					while { [lindex $data $k3] != "BRANCH4" } {
						incr k3
					}
					incr k3

					while { $k3 < [llength $data] } {
	
						if { [lindex $data $k3] == $t1 && [lindex $data [expr { $k3 + 1 }]] == $t2 && [lindex $data [expr { $k3 + 2 }]] == $t3 && [lindex $data [expr { $k3 + 3 }]] == $t4 } { 
							set t5 [lindex $data [expr { $k3 + 4 }]] 

							set f4 [open "$t1.$t2.$t3.$t4.$t5" "r"]
							set data4 [read $f4]
							close $f4

							set res4 [lindex $data4 0]

							puts $g "## PATH $p"
							puts $g "$res0 $res1 $res2 $res3 $res4"

							puts "## PATH $p"
							puts "$res0 $res1 $res2 $res3 $res4"

							incr p
						}
						incr k3 5
					}
				}
				incr k2 4
			}
		}
		incr k1 3
	}
	incr k 2
}
close $g







