#!/usr/bin/perl
#$Id: versions.t,v 1.7 2002/03/09 18:19:43 epa98 Exp $

use strict;
use Sort::Versions;

my @tests;
while(<DATA>) {
	if(/^\s*(\S+)\s*([<>])\s*(\S+)\s*$/) {
		push @tests, $1,$3 if $2 eq "<";
		push @tests, $3,$1 if $2 eq ">";
	}
}

print "1..", (@tests * 2) + 3, "\n";

my @l = sort versions qw(1.2 1.2a);
print "not " if $l[0] ne "1.2";
print "ok 1\n";

@l = sort { versioncmp($a, $b) } qw(1.2 1.2a);
print "not " if $l[0] ne "1.2";
print "ok 2\n";

if ($] >= 5.006) {
    @l = sort versioncmp qw(1.2 1.2a);
    print "not " if $l[0] ne "1.2";
    print "ok 3\n";
}
else {
    # Sort subroutines have to use $a and $b, skip test.
    print "ok 3\n";
}

my $i=4;
while (@tests) {
    ($a, $b) = @tests[0, 1];
    print "#$i:\t$a\t<\t$b\n";

    # Test both the versioncmp() and versions() interfaces, in both
    # the main package and other packages.
    #
    if (versions != -1) {
	print 'not ';
    }
    print "ok $i\n";
    $i++;

    if (versioncmp($a, $b) != -1) {
	print 'not ';
    }
    print "ok $i\n";
    $i++;
	
    undef $a; undef $b; # just in case
    {
	package Foo;
	use Sort::Versions;
	($a, $b) = @tests[0, 1];

	if (versions != -1) {
	    print 'not ';
	}
	print "ok $i\n";
	$i++;

	if (versioncmp($a, $b) != -1) {
	    print 'not ';
	}
	print "ok $i\n";
	$i++;
    }

    shift @tests; shift @tests;
}


__END__

1.2 < 1.2.b
1.2   < 1.3
1.2   < 1.2.1
1.2.1 < 1.3
1.2   < 1.2a
1.2a  < 1.3
1.2.1 < 1.2a
1.2.b < 1.2a
a     < b
a.b   < a.c
a.1   < a.a
1 < a
1a < a
1a < 2
1..1 < 1.1.1
a < a.b
1 > 0002
1.5 > 1.06
1 < 1-1
1-1 < 1-2
1-2 < 1.2
1-2 < 1.0-1
1-2 < 1.0
1-2 < 1.3
1.3-4.6-7 < 1.3-4.8
1.3-4.6-7 < 1.3-4.6.7
1.3-4a-7 < 1.3-4a-7.4
