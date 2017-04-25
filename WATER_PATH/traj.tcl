proc cpptraj { res } {

	set start 1600
	set end 1700
	set step 5

	# EXECUTING CPPTRAJ 

	set f [open "input" "w"]

	puts $f "trajin prod1_w.nc $start $end $step"
	puts $f "hbond out hb.dat angle -1 donormask !:$res acceptormask :$res avgout avghb.dat"
	puts $f "go"

	close $f

	exec cpptraj -p molf.prmtop -i input

	exec tclsh hbond_sort.tcl

}

proc traj {} {

	set b [open "branch" "w"]
		
	# INITIALISING THE ARRAY

	for {set j 0} {$j < 100} {incr j} {
		set nb2($j) 0
		for {set m 0} {$m < 100 } {incr m} {
			set nb3($j,$m) 0
			for {set n 0} {$n < 100} {incr n} {
				set nb4($j,$m,$n) 0
			}
		}
	}

	set num_branch 5
	set j 0

	set k1 0

	# BRANCH 0

	puts "				#### BRANCH 0 ####"

	set firstres 6667
	set resid $firstres

	set f [open "sorted_ac_list" "w"]
	
	puts $f "$resid"
	close $f

	puts "				**** H BOND FOR RESIDUE $resid ****"
	set r($k1) $resid
	incr k1
	cpptraj $resid

	set h [open "sorted_hbond_sel" "r"]
	set data [read $h]
	close $h
	
	set g [open "$j" "w"]	
	puts $g "$data"
	close $g

	# BRANCH 1

	puts $b "## BRANCH 1"

	puts "				#### BRANCH 1 ####"

	set g [open "$j" "r"]
	set data [read $g]
	close $g

	set k 2
	set i 0
	while { $k < [llength $data] } {
		set resid [lindex $data $k]

		set count 0
		for {set l 0} {$l < $k1} {incr l} {
			if { $resid == $r($l) } {
				incr count
			}
		} 
		if { $count == 0 } {
			set f [open "sorted_ac_list" "w"]
	
			puts $f "$resid"
			close $f

			puts "				**** H BOND FOR RESIDUE $resid ****"
			set r($k1) $resid
			incr k1
			cpptraj $resid

			set h [open "sorted_hbond_sel" "r"]
			set data1 [read $h]
			close $h 
		
			set g [open "$j.$i" "w"]	
			puts $g "$data1"
			close $g

			puts $b "$j $i"
		
			incr i
		}
		incr k 3
	}
	
	set nb1 $i

	# BRANCH 2

	puts $b "## BRANCH 2"

	puts "				#### BRANCH 2 ####"

	for {set i 0} {$i < $nb1} {incr i} {

		set g [open "$j.$i" "r"]
		set data [read $g]
		close $g
	
		set k 2
		set m 0
		while { $k < [llength $data] } {

			set resid [lindex $data $k]

			set count 0
			for {set l 0} {$l < $k1} {incr l} {
				if { $resid == $r($l) } {
					incr count
				}
			} 

			if { $count == 0 } {

				set f [open "sorted_ac_list" "w"]
	
				puts $f "$resid"
				close $f

				puts "				**** H BOND FOR RESIDUE $resid ****"
				set r($k1) $resid
				incr k1
				cpptraj $resid

				set h [open "sorted_hbond_sel" "r"]
				set data1 [read $h]
				close $h 
		
				set g [open "$j.$i.$m" "w"]	
				puts $g "$data1"
				close $g

				puts $b "$j $i $m"

				incr m
			}
			incr k 3
		}
		set nb2($i) $m

	}

	# BRANCH 3

	puts $b "## BRANCH 3"

	puts "				#### BRANCH 3 ####"
	set n 0
	for {set n 0} {$n < $nb1} {incr n} {
		for {set i 0} {$i < $nb2($n)} {incr i} {
			set g [open "$j.$n.$i" "r"]
			set data [read $g]
			close $g
	
			set k 2
			set m 0
			while { $k < [llength $data] } {
				set resid [lindex $data $k]

				set g1 [open "$j" "r"]
				set data2 [read $g1]
				close $g1

				set count 0
				for {set l 0} {$l < $k1} {incr l} {
					if { $resid == $r($l) } {
						incr count
					}
				} 
				if { $count == 0 } {
					set f [open "sorted_ac_list" "w"]
	
					puts $f "$resid"
					close $f

					puts "				**** H BOND FOR RESIDUE $resid ****"
					set r($k1) $resid
					incr k1
					cpptraj $resid

					set h [open "sorted_hbond_sel" "r"]
					set data1 [read $h]
					close $h 
		
					set g [open "$j.$n.$i.$m" "w"]	
					puts $g "$data1"
					close $g

					puts $b "$j $n $i $m"
		
					incr m
				}
				incr k 3
			}
			set nb3($n,$i) $m
		}
	} 

	# BRANCH 4

	puts $b "## BRANCH 4"

	puts "				#### BRANCH 4 ####"

	for {set o 0} {$o < $nb1} {incr o} {
		for {set n 0} {$n < $nb2($o)} {incr n} {
			for {set i 0} {$i < $nb3($o,$n)} {incr i} {

				set g [open "$j.$o.$n.$i" "r"]
				set data [read $g]
				close $g
	
				set k 2
				set m 0
				while { $k < [llength $data] } {
					set resid [lindex $data $k]
					set count 0
					for {set l 0} {$l < $k1} {incr l} {
						if { $resid == $r($l) } {
							incr count
						}
					} 
					if { $count == 0 } {
						set f [open "sorted_ac_list" "w"]
	
						puts $f "$resid"
						close $f

						puts "				**** H BOND FOR RESIDUE $resid ****"
						set r($k1) $resid
						incr k1
						cpptraj $resid

						set h [open "sorted_hbond_sel" "r"]
						set data1 [read $h]
						close $h 
		
						set g [open "$j.$o.$n.$i.$m" "w"]	
						puts $g "$data1"
						close $g
		
						puts $b "$j $o $n $i $m"

						incr m
					}
					incr k 3
				}
				set nb4($o,$n,$i) $m
			}
		}
	}

	close $b

	# GETTING THE PROTON PATHS

	#set f [open "path" "w"]
	#set res0 $firstres
	#set p 0
	#for {set i 0} {$i < $nb1} {incr i} {
		#set f1 [open "0.$i" "r"]
		#set data1 [read $f1]
		#close $f1
		#set res1 [lindex $data1 0]

		#for {set j 0} {$j < $nb2($j)} {incr j} {
			#set f2 [open "0.$i.$j" "r"]
			#set data2 [read $f2]
			#close $f2
			#set res2 [lindex $data2 0]

			#for {set m 0} {$m < $nb3($j,$m)} {incr m} {
				#set f3 [open "0.$i.$j.$m" "r"]
				#set data3 [read $f3]
				#close $f3
				#set res3 [lindex $data3 0]

				#for {set n 0} {$n < $nb4($j,$m,$n)} {incr n} {
					#set f4 [open "0.$i.$j.$m.$n" "r"]
					#set data4 [read $f4]
					#close $f4
					#set res4 [lindex $data4 0]

					#puts "				## PATH $p"
					#puts "				$res0 $res1 $res2 $res3 $res4"
					#puts $f " ## PATH $p"
					#puts $f "$res0 $res1 $res2 $res3 $res4"
					#incr p
				#}
			#}
		#}
	#}
	#close $f
}

proc del {} {
	for {set i 0} {$i < $nb1} {incr i} {
		file delete 0.$i
		for {set j 0} {$j < $nb2($i)} {incr j} {
			file delete 0.$i.$j
			for {set m 0} {$m < $nb3($i,$m)} {incr m} {
				file delete 0.$i.$j.$m
				for {set n 0} {$n < $nb4($i,$m,$n)} {incr n} {
					file delete 0.$i.$j.$m.$n
				}
			}
		}
	}
}

traj
#del











