#!/usr/bin/perl -w

# Test to see if we've worked around some wacky sort/threading bug
# See [rt.cpan.org 6782]

BEGIN {
    if( $ENV{PERL_CORE} ) {
        chdir 't';
        @INC = ('../lib', 'lib');
    }
    else {
        unshift @INC, 't/lib';
    }
}

use strict;
use Config;

BEGIN {
    require threads if $Config{useithreads};
}
use Test::More;

# Passes with $nthreads = 1 and with eq_set().
# Passes with $nthreads = 2 and with eq_array().
# Fails  with $nthreads = 2 and with eq_set().
my $nthreads = 2;

if( $Config{useithreads} ) {
    plan tests => $nthreads;
}
else {
    plan skip_all => 'no threads';
}


sub do_one_thread {
    my $kid = shift;
    my @list = ( 'x', 'yy', 'zzz', 'a', 'bb', 'ccc', 'aaaaa', 'z',
                 'hello', 's', 'thisisalongname', '1', '2', '3',
                 'abc', 'xyz', '1234567890', 'm', 'n', 'p' );
    my @list2 = @list;
    print "# kid $kid before eq_set\n";

    for my $j (1..99) {
        # With eq_set, either crashes or panics
        eq_set(\@list, \@list2);
        eq_array(\@list, \@list2);
    }
    print "# kid $kid exit\n";
    return 42;
}

my @kids = ();
for my $i (1..$nthreads) {
    my $t = threads->new(\&do_one_thread, $i);
    print "# parent $$: continue\n";
    push(@kids, $t);
}
for my $t (@kids) {
    print "# parent $$: waiting for join\n";
    my $rc = $t->join();
    cmp_ok( $rc, '==', 42, "threads exit status is $rc" );
}
