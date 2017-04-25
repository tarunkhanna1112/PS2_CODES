proc initial_PDB {} {
	# CHAIN ID AND RESNAME FROM THE INITIAL PDB

	set f [open "[lindex $::argv 0]" "r"]
	set data [read $f]
	close $f

	set g [open "MONOMER_A.dat" "w"]
	set h [open "MONOMER_a.dat" "w"]
	set g1 [open "MONOMER_A_RES.dat" "w"]
	set h1 [open "MONOMER_a_RES.dat" "w"]

	set k 0
	while { [lindex $data $k] != "CRYST1" } {
		incr k
	}

	set nchain 0
	set res ""
	set resn ""
	set pos 0
	set old_id -1
	puts $g "\{"
	puts $g1 "\{"
	while { [lindex $data [expr { $k + 4 }]] != "a" } {
		if { [lindex $data $k] == "TER" } {	
			puts $g1 "$resn"
			puts $g "$res"
			set res ""
			set resn ""
			set pos 0
			set memk $k
			incr nchain
			puts $g "\}"
			puts $g "\{"
			puts $g1 "\}"
			puts $g1 "\{"
		}
		if { [lindex $data $k] == "ATOM" } {
			set resname [lindex $data [expr { $k + 3 }]]
			set sresname [string length $resname]
			if { $sresname < 3 } {
				set shift 1
				set temp [lindex $data [expr { $k + 3 - $shift }]]
				set resname [string range $temp [expr { [string length $temp] - 3 }] [string length $temp]]
			} else {
				set shift 0
			}
			set id [lindex $data [expr { $k + 5 - $shift }]]
			if { $id != $old_id } {
				set res [linsert $res $pos $id]
				set resn [linsert $resn $pos $resname]
				incr pos
			}
			set old_id $id
		}
		incr k
	}
	close $g
	close $g1
	puts "				### MONOMER A HAS $nchain CHAINS ###"

	set k [expr { $memk + 1 }]
	set nchain 0
	set res ""
	set resn ""
	set pos 0
	set old_id -1
	puts $h "\{"
	puts $h1 "\{"
	while { $k < [llength $data]  } {
		if { [lindex $data $k] == "TER" } {
			puts $h "$res"
			puts $h1 "$resn"
			set res ""
			set resn ""
			set pos 0
			incr nchain
			puts $h "\}"
			puts $h "\{"
			puts $h1 "\}"
			puts $h1 "\{"
		}
		if { [lindex $data $k] == "ATOM" } {
			set resname [lindex $data [expr { $k + 3 }]]
			set sresname [string length $resname]
			if { $sresname < 3 } {
				set shift 1
				set temp [lindex $data [expr { $k + 3 - $shift }]]
				set resname [string range $temp [expr { [string length $temp] - 3 }] [string length $temp]]
			} else {
				set shift 0
			}
			set id [lindex $data [expr { $k + 5 - $shift }]]
			if { $id != $old_id } {
				set res [linsert $res $pos $id]
				set resn [linsert $resn $pos $resname]
				incr pos
			}
			set old_id $id
		}
		incr k
	}
	close $h
	close $h1
	puts "				### MONOMER a HAS $nchain CHAINS ###"
}

proc MD_PDB {} {
	# CHAIN ID AND RESNAME FROM THE MD PDB

	puts "			#### ENTER THE NUMBER OF CHAINS PER MONOMER ####"
	set inp1 [gets stdin]
	puts ""

	set f [open "[lindex $::argv 0]" "r"]
	set data [read $f]
	close $f

	set g [open "MONOMER_A_MD.dat" "w"]
	set h [open "MONOMER_a_MD.dat" "w"]
	set g1 [open "MONOMER_A_RES_MD.dat" "w"]
	set h1 [open "MONOMER_a_RES_MD.dat" "w"]

	set k 0
	while { [lindex $data $k] != "CRYST1" } {
		incr k
	}

	set ccount 0
	set nchain 0
	set res ""
	set resn ""
	set pos 0
	set old_id -1
	puts $g "\{"
	puts $g1 "\{"
	while { $ccount < $inp1 } {
		if { [lindex $data $k] == "TER" } {	
			incr ccount
			puts $g1 "$resn"
			puts $g "$res"
			set res ""
			set resn ""
			set pos 0
			set memk $k
			incr nchain
			puts $g "\}"
			puts $g "\{"
			puts $g1 "\}"
			puts $g1 "\{"
		}
		if { [lindex $data $k] == "ATOM" } {
			set resname [lindex $data [expr { $k + 3 }]]
			set sresname [string length $resname]
			if { $sresname < 3 } {
				set shift 1
				set temp [lindex $data [expr { $k + 3 - $shift }]]
				set resname [string range $temp [expr { [string length $temp] - 3 }] [string length $temp]]
			} else {
				set shift 0
			}
			set id [lindex $data [expr { $k + 4 - $shift }]]
			if { $id != $old_id } {
				set res [linsert $res $pos $id]
				set resn [linsert $resn $pos $resname]
				incr pos
			}
			set old_id $id
		}
		incr k
	}
	close $g
	close $g1
	puts "				### MONOMER A HAS $nchain CHAINS ###"

	set k [expr { $memk + 1 }]
	set ccount 0
	set nchain 0
	set res ""
	set resn ""
	set pos 0
	set old_id -1
	puts $h "\{"
	puts $h1 "\{"
	while { $ccount < $inp1 } {
		if { [lindex $data $k] == "TER" } {
			incr ccount
			puts $h "$res"
			puts $h1 "$resn"
			set res ""
			set resn ""
			set pos 0
			incr nchain
			puts $h "\}"
			puts $h "\{"
			puts $h1 "\}"
			puts $h1 "\{"
		}
		if { [lindex $data $k] == "ATOM" } {
			set resname [lindex $data [expr { $k + 3 }]]
			set sresname [string length $resname]
			if { $sresname < 3 } {
				set shift 1
				set temp [lindex $data [expr { $k + 3 - $shift }]]
				set resname [string range $temp [expr { [string length $temp] - 3 }] [string length $temp]]
			} else {
				set shift 0
			}
			set id [lindex $data [expr { $k + 4 - $shift }]]
			if { $id != $old_id } {
				set res [linsert $res $pos $id]
				set resn [linsert $resn $pos $resname]
				incr pos
			}
			set old_id $id
		}
		incr k
	}
	close $h
	close $h1
	puts "				### MONOMER a HAS $nchain CHAINS ###"
}

puts "		#### ENTER THE CORRECT OPTION ####"
puts "		#### 0 = PDB FROM PDB DATABASE ####"
puts "		#### 1 = PDB AFTER MD SIMULATION ###"
set inp [gets stdin]
puts ""
if { $inp == "0" } {
	initial_PDB
} elseif { $inp == "1" } {
	MD_PDB
} elseif { $inp != 0 || $inp != 1 } {
	puts ""
	puts "		#### INCORRECT INPUT ####"
	exit
}








