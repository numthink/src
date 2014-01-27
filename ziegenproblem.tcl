#!/usr/bin/tclsh
puts "++ Das Ziegenproblem ++\n"

# Procedure to calculate the probability of winning after N runs
# when user don't change and change doors
#
proc calc_prob {nn} {

    # 1st loop: [0] don't change doors; [1] change doors
    for {set change_doors 0} {$change_doors <= 1} {incr change_doors} {
        set accum 0

        # 2nd loop: simulate $nn times and accumulates results
        for {set ii 0} {$ii < $nn} {incr ii} {

            set p_prize   [expr {1 + int(floor(rand()*3))}];
            set p_user_1  [expr {1 + int(floor(rand()*3))}];

            # user chose right door at first guess
            if {$p_user_1 == $p_prize} {
                set p_host $p_prize;
                while {$p_host == $p_prize} {
                    set p_host    [expr {1 + int(floor(rand()*3))}];
                }
            # user chose wrong door at first guess
            } else {
                if       {($p_prize == 1) && ($p_user_1 == 2)} {
                    set p_host 3;
                } elseif {($p_prize == 1) && ($p_user_1 == 3)} {
                    set p_host 2;
                } elseif {($p_prize == 2) && ($p_user_1 == 1)} {
                    set p_host 3;
                } elseif {($p_prize == 2) && ($p_user_1 == 3)} {
                    set p_host 1;
                } elseif {($p_prize == 3) && ($p_user_1 == 1)} {
                    set p_host 2;
                } elseif {($p_prize == 3) && ($p_user_1 == 2)} {
                    set p_host 1;
                } else                                         {
                    puts "Error!\n";
                }
            }

            # user final guess after opportunity to change doors
            if ($change_doors) {
                if       {($p_user_1 == 1) && ($p_host == 2)} {
                    set p_user_2 3;
                } elseif {($p_user_1 == 1) && ($p_host == 3)} {
                    set p_user_2 2;
                } elseif {($p_user_1 == 2) && ($p_host == 1)} {
                    set p_user_2 3;
                } elseif {($p_user_1 == 2) && ($p_host == 3)} {
                    set p_user_2 1;
                } elseif {($p_user_1 == 3) && ($p_host == 1)} {
                    set p_user_2 2;
                } elseif {($p_user_1 == 3) && ($p_host == 2)} {
                    set p_user_2 1;
                } else                                        {
                    puts "Error!\n";
                }
            } else {
              set p_user_2 $p_user_1;
            }

            # check and store user result into accumulator
            if {$p_user_2 == $p_prize} {
                set won 1;
            } else {
                set won 0;
            }

            set accum [expr {$accum + $won}];
        }

        # winning percentage after $nn runs
        set result [lappend result [expr {100.0 * $accum / $ii}]];
    }
    return $result

}

for {set ii 10} {$ii <= 1000000} {set ii [expr $ii * 10]} {
    set result [calc_prob $ii]
    puts "\[$ii\] Winning chance: not changing doors: [lindex $result 0], changing doors: [lindex $result 1]";
}
