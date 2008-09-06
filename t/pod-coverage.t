#!/usr/bin/perl -w
# $Id: /mirror/googlecode/test-more/t/pod-coverage.t 57943 2008-08-18T02:09:22.275428Z brooklyn.kid51  $

use Test::More;

# 1.08 added the coverage_class option.
eval "use Test::Pod::Coverage 1.08";
plan skip_all => "Test::Pod::Coverage 1.08 required for testing POD coverage" if $@;
eval "use Pod::Coverage::CountParents";
plan skip_all => "Pod::Coverage::CountParents required for testing POD coverage" if $@;

my @modules = Test::Pod::Coverage::all_modules();
plan tests => scalar @modules;

my %coverage_params = (
    "Test::Builder" => {
        also_private => [ '^(share|lock|BAILOUT)$' ]
    },
    "Test::More" => {
        trustme => [ '^(skip|todo)$' ]
    },
);

for my $module (@modules) {
    pod_coverage_ok( $module, { coverage_class => 'Pod::Coverage::CountParents',
                                %{$coverage_params{$module} || {}} }
                   );
}
