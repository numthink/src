#!/usr/bin/perl
# ------------------------------------------------------------------------------
# Simulation of Diffie-Hellman method for cryptographic key exchange.
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

use bignum;

$p  = 1234567891;
$g  = int(rand(1000)) + 1000;

for ($ii = 0; $ii < 10; $ii++) {

    $sa = int(rand(1000)) + 1000;
    $sb = int(rand(1000)) + 1000;

    $pa = ($g ** $sa) % $p;
    $pb = ($g ** $sb) % $p;

    $ka = ($pb ** $sa) % $p;
    $kb = ($pa ** $sb) % $p;

    if (!$ii) {
            printf "         g |          p |         sa |         sb |         pa |         pb |         ka |         kb \n", $g, $p, $sa, $sb, $pa, $pb, $ka, $kb;
            printf "-----------+------------+------------+------------+------------+------------+------------+----------- \n", $g, $p, $sa, $sb, $pa, $pb, $ka, $kb;
    }
    printf "%10d | %10d | %10d | %10d | %10d | %10d | %10d | %10d \n", $g, $p, $sa, $sb, $pa, $pb, $ka, $kb;

}
