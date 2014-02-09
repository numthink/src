#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Simple algorithm for prime number generation.
#
# Copyright (C) 2014: NumThink
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Very simple, non-optimised, cryptographically useless and legally harmless :-)
# algorithm to check if a number is prime.
# ------------------------------------------------------------------------------

sub check_prime {
    my $nn;
    my $ii;
    my $res;

    $nn = $_[0];                         # input number to be tested
    $ii = 2;                             # start dividing by 2
    do {
        $res = $nn % $ii;                # calcule division remainder
        if ($ii==2) { $ii = $ii+1; }     # skip even dividers after 2 is tested
        else        { $ii = $ii+2; }
    } while ($res && ($ii<=int($nn/2))); # look for dividers until mid range
    
    return $res ? 1 : 0;                 # return 1 if no divider was found
}

# ------------------------------------------------------------------------------
# Function to return next prime number if input is not a prime.
# ------------------------------------------------------------------------------

sub next_prime {
    my $nn;
    my $prime;
    my $ii;

    $nn = $_[0];                         # input number to be tested
    $prime = &check_prime($nn);          # check if input is prime

    if ($prime) {                        # if input is prime then return
        return $nn;
    } else {                             # if input is not prime search for next one
        for ($ii=$nn+1;;$ii++) {
            $prime = &check_prime($ii);
            if ($prime) {
                return $ii;
            }
        }
    }
}

# ------------------------------------------------------------------------------
# Main program
# ------------------------------------------------------------------------------

if ($#ARGV < 0) {
    print "Pass number of list of numbers to be tested for prime.\n";
    print "If number is not prime the next one will be output.\n";
    break;
}

# Check if all input arguments are prime numbers
 foreach (@ARGV) {

    $prime = &next_prime($_);            # check if argument is a prime number,
                                         # if not prime search for next one
    if ($_ == $prime) {
        print "\t$_ is prime.\n";
    } else {
        print "\t$_ is not prime; next prime is $prime.\n";
    }
}

# ------------------------------------------------------------------------------
# END
# ------------------------------------------------------------------------------
