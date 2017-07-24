# THIS SCRIPT CALCULATE THE RMSF PER RESIDUE AND CONVERTS INTO AN AVERAGE RMSF PER RESIDUE tclsh rmsf_csv.tcl $input $output

set f [open "[lindex $::argv 0]" "r"]
set data [read $f]
close $f

set g [open "[lindex $::argv 1].txt" "w"]

# COUNTING THE NUMBER OF RESIDUES
set k 1
set j 0
while { [lindex $data $k] != 1 } {
	set resname($j) [string range [lindex $data $k] 0 2]
	incr k
	incr j
}

set nres [expr { $k - 1 }]

# RESIDDUE VARIABLES

for {set i 0} {$i < $nres} {incr i} {
	set res($i) 0.0
}

# COUNTING THE NUMBER OF FRAMES

set k1 $k
set nframes 0
while { $k1 < [llength $data] } {
	incr k1 $nres
	incr nframes
}

for {set i 1} {$i <= $nframes} {incr i} {
	incr k
	set j 0
	while { [lindex $data $k] != [expr { $i + 1 }] && $k < [llength $data] } {
		set res($j) [expr { $res($j) + [lindex $data $k] }]
		incr k
		incr j
	}
}

# AVERAGING THE VALUES AND PUTTING IN A TEXT FILE
set resid 212
for {set i 0} {$i < $nres} {incr i} {
	set res($i) [expr { $res($i) / $nframes }]
	puts $g "$resname($i) $resid	$res($i)"
	incr resid
}	

close $g
