#!/usr/bin/perl

# Test TB2::Mouse will load.
# Don't use any Test::Builder stuff here because it relies on TB2::Mouse

use strict;
use warnings;

use Test::Builder2::Mouse;

print <<'END';
1..1
ok 1 - Test::Builder2::Mouse loaded
END


