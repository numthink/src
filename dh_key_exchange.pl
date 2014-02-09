#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Simulation of Diffie-Hellman exchange key method for symmetric encryption.
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

use bignum;                              # partial results can be big numbers

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
# Simulation of Diffie-Hellman exchange key method for symmetric encryption.
# ------------------------------------------------------------------------------

# The Diffie-Hellman exchange key method is used to safely exchange keys
# for symmetric excryption, based on the following steps:
#
# (1) prime number 'p' and primitive root 'g' are public and openly exchanged
#     between the parts, say Ada and Linda;
# (2) Ada chooses a secrete integer 'a' and calculates
#     A = (g**a) mod p
# (3) Linda chooses a secrete integer 'b' and calculates
#     B = (g**b) mod p
# (4) Ada sends 'a' to Linda, who sends 'b' to Ada
# (5) Ada calculates the common (but secret) key
#     key = (B**a) mod p
# (6) Linda calculates the common (but secret) key
#     key = (A**b) mod p
#
# Notes:
# (1) 'p' has to be a big prime number, the bigger the better.
#     To limit execution time, current program uses a fixed 10-digit prime
#     number for 'p', which is very small for cryptographic purposes but
#     serves well for this example.
# (2) 'g' does need to be big.
# (3) 'p', 'g', 'a' and 'b' are kept secret, whilst 'A' and 'B' are openly
#     exchanged. Final key is calculated locally by each part, implying that,
#     technically, the key is not really exchanged between parts.
# (4) The two protagonits were named after Ada and Linda Lovelace. ;-)

for ($ii = 0; $ii < 13; $ii++) {             # run a few times to make sure it works
    
    $g = &next_prime(int(rand(9) ) + 3  );   # choose small prime for g
    
    #$p = &next_prime(int(rand(1e6)) + 1e6); # use fixed value for p to reduce
    $p  = 1234567891;                        # execution time

    $sa = int(rand(1e3)) + 1e3;              # choose secret a and b
    $sb = int(rand(1e3)) + 1e3;

    $pa = ($g ** $sa) % $p;                  # calculate public A and B
    $pb = ($g ** $sb) % $p;

    $ka = ($pb ** $sa) % $p;                 # calculate secret key
    $kb = ($pa ** $sb) % $p;

    if (!$ii) {
            print "  (public) g |  (public) p | (private) a | (private) b |  (public) A |  (public) B |       key A |       key B | keys matched \n";
            print "-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+--------------\n";
    }
    $match = ($ka == $kb) ? "yes" : "no";
    printf " %11d | %11d | %11d | %11d | %11d | %11d | %11d | %11d | %s \n", $g, $p, $sa, $sb, $pa, $pb, $ka, $kb, $match;
}

# ------------------------------------------------------------------------------
# END
# ------------------------------------------------------------------------------
