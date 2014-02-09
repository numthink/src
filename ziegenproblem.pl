#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Simulation of goat's problem (Monty Hall) winning probability.
#
# Copyright (C) 2014: NumThink
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------------

print "++ Das Ziegenproblem ++\n";

# Function to calculate the probability of winning after N runs
# when user don't change and change doors
#
sub calc_prob {
    $nn = $_[0]; # number of runs
    
    # 1st loop: [0] don't change doors; [1] change doors
    for ($change_doors=0; $change_doors<=1; $change_doors++) {
        $accum = 0;
        
        # 2nd loop: simulate $nn times and accumulates results
        for ($ii=0; $ii<$nn; $ii++) {

            $p_prize  = int(rand(3)) + 1;
            $p_user_1 = int(rand(3)) + 1;

            # user chose right door at first guess
            if($p_user_1 == $p_prize) {
                $p_host = $p_prize;
                while($p_host == $p_prize) {
                    $p_host = int(rand(3)) + 1;
                }
            # user chose wrong door at first guess
            } else {
                if    (($p_prize == 1) && ($p_user_1 == 2)) { $p_host = 3; }
                elsif (($p_prize == 1) && ($p_user_1 == 3)) { $p_host = 2; }
                elsif (($p_prize == 2) && ($p_user_1 == 1)) { $p_host = 3; }
                elsif (($p_prize == 2) && ($p_user_1 == 3)) { $p_host = 1; }
                elsif (($p_prize == 3) && ($p_user_1 == 1)) { $p_host = 2; }
                elsif (($p_prize == 3) && ($p_user_1 == 2)) { $p_host = 1; }
                else                                        { print "Error!\n"; }
            }

            # user final guess after opportunity to change doors
            if ($change_doors) {
                if    (($p_user_1 == 1) && ($p_host == 2)) { $p_user_2 = 3; }
                elsif (($p_user_1 == 1) && ($p_host == 3)) { $p_user_2 = 2; }
                elsif (($p_user_1 == 2) && ($p_host == 1)) { $p_user_2 = 3; }
                elsif (($p_user_1 == 2) && ($p_host == 3)) { $p_user_2 = 1; }
                elsif (($p_user_1 == 3) && ($p_host == 1)) { $p_user_2 = 2; }
                elsif (($p_user_1 == 3) && ($p_host == 2)) { $p_user_2 = 1; }
                else                                       { print "Error!\n"; }
            } else {
              $p_user_2 = $p_user_1;
            }

            # check and store user result into accumulator
            if ($p_user_2 == $p_prize) { $won = 1; }
            else                       { $won = 0; }

            $accum = $accum + $won;
            $values[$ii] = $won;
        }
        # winning percentage after $nn runs
        $result[$change_doors] = (100 * $accum / $ii);
    }
    $result[2] = $result[0] + $result[1];
    @return = @result;
} # end: calc_prob


sub calc_std {
    @values = @_;
    $nn = scalar @values;
    
    # calculate mean
    $accum = 0;
    foreach $sample (@values) {
        $accum = $accum + $sample;
        #print "sample:$sample; accum: $accum\n";
    }
    $mean = $accum / $nn;

    # calculate standard deviation
    $std_accum = 0;
    foreach $sample (@values) {
        $std_accum = $std_accum + (($sample - $mean)**2);
        #print "n:$nn \t mean:$mean \t sample:$sample \t std_accum:$std_accum\n";
    }
    $std = ($std_accum / ($nn-1))**(1/2);
    
    # return mean and standard deviation
    $result[0] = $mean;
    $result[1] = $std;
    #print "n:$nn \t mean:$mean \t std:$std\n";
    @return = @result;
}

for ($jj=10; $jj<=1_000_000; $jj*=10) {

    for ($kk=0; $kk<100; $kk++) {
        @prob = &calc_prob($jj);
        $change_n[$kk] = $prob[0];
        $change[$kk]   = $prob[1];
    }
    
    @temp = &calc_std(@change_n);
    $mean_change_n[$jj] = $temp[0];
    $std_change_n[$jj]  = $temp[1];
    
    @temp = &calc_std(@change);
    $mean_change[$jj]   = $temp[0];
    $std_change[$jj]    = $temp[1];
    
    $total =$mean_change_n[$jj] + $mean_change[$jj];
    printf "[%7d] Winning chance: not changing doors (mean/std) = %4.1f%::%4.1f%; \t changing doors (mean/std) = %4.1f%::%4.1f%; \t total = %5.1f%\n", $jj, $mean_change_n[$jj], $std_change_n[$jj], $mean_change[$jj], $std_change[$jj], $total;
}
