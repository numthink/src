#!/usr/bin/tclsh
puts "++ Das Ziegenproblem ++\n"

for {set troca 0} {$troca <= 1} {incr troca} {

    set ganhou_acum 0
    for {set ii 0} {$ii < 10000} {incr ii} {

        set p_carro   [expr {1 + int(floor(rand()*3))}];
        set p_user_1  [expr {1 + int(floor(rand()*3))}];

        if {$p_user_1 == $p_carro} {
            set p_host $p_carro;
            while {$p_host == $p_carro} {
                set p_host    [expr {1 + int(floor(rand()*3))}];
            }
        } else {
            if       {($p_carro == 1) && ($p_user_1 == 2)} {
                set p_host 3;
            } elseif {($p_carro == 1) && ($p_user_1 == 3)} {
                set p_host 2;
            } elseif {($p_carro == 2) && ($p_user_1 == 1)} {
                set p_host 3;
            } elseif {($p_carro == 2) && ($p_user_1 == 3)} {
                set p_host 1;
            } elseif {($p_carro == 3) && ($p_user_1 == 1)} {
                set p_host 2;
            } elseif {($p_carro == 3) && ($p_user_1 == 2)} {
                set p_host 1;
            } else                                         {
                puts "Erro!\n";
            }
        }

        if ($troca) {
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
                puts "Erro!\n";
            }
        } else {
          set p_user_2 $p_user_1;
        }

        if {$p_user_2 == $p_carro} {
            set ganhou 1;
        } else {
            set ganhou 0;
        }

        set ganhou_acum [expr {$ganhou_acum + $ganhou}];

#        puts "\[$ii\] p_carro: $p_carro, p_user_1: $p_user_1, p_host: $p_host, p_user_2: $p_user_2, ganhou: $ganhou, ganhou_acum: $ganhou_acum";
    }

    set ganhou_p100 [expr {100.0 * $ganhou_acum / $ii}];
    puts "Troca:$troca, n = $ii, ganhou $ganhou_p100%";
}
