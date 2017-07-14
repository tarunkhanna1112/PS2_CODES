# GENERATING A CSV FILE WITH THE NEIGBOUR INFORMATION ABOUT THE NEAREST NEIGBOURS tclsh ac_pdb.tcl output pdb_map md_map h_bond_sorted_file

package require csv

set f [open "[lindex $::argv 0].csv" "w"]

# RESIDUE ID'S FROM THE PDB FILE

set g1 [open "[lindex $::argv 1]" "r"]
set data [read $g1]
close $g1

# CORRESPONDING RESIDUE IDS FROM MD

set g2 [open "[lindex $::argv 2]" "r"]
set data1 [read $g2]
close $g2

# H-BOND FILES

set g3 [open "[lindex $::argv 3]" "r"]
set data2 [read $g3]
close $g3

set all_list ""
set k 2

while { $k < [llength $data2] } {
	set col ""
	set res [lindex $data2 $k]
	set resid [lindex $data2 [expr { $k + 2 }]]
	
	# FINDING THE resid IN PDB FILE
	set k1 0
	while { $k1 < 19 } {
		set k2 0
		set cpos -1
		while { $k2 < [llength [lindex $data1 $k1]] } {
			set resmd [lindex $data1 $k1 $k2]
			if { $resmd == $resid } {
				set cpos $k1
				set mdpos $k2
				set k2 [llength [lindex $data1 $k1]]
				set k1 20
			}
			incr k2
		}
		incr k1
	}
	if { $cpos != -1 } {
		set residpdb [lindex $data $cpos $mdpos]

		set frac [lindex $data2 [expr { $k + 1 }]]
		set dis [lindex $data2 [expr { $k + 3 }]]
		set angle [lindex $data2 [expr { $k + 4 }]]

		lappend col $res $residpdb $dis $angle $frac [expr { $cpos + 1 }]
	
		lappend all_list $col
	}

	incr k 5
}
puts $f [csv::joinlist $all_list]
close $f



