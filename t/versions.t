#!/usr/bin/perl

#$Id: versions.t,v 1.3 2001/07/28 17:07:48 epa98 Exp $

use Sort::Versions;

while(<DATA>) {
	if(/^\s*(\S+)\s*([<>])\s*(\S+)\s*$/) {
		push @tests, $1,$3 if $2 eq "<";
		push @tests, $3,$1 if $2 eq ">";
	}
}

print "1..",@tests/2+1,"\n";

@l = sort versions qw (1.2 1.2a);
print "not " if $l[0] ne "1.2";
print "ok 1\n";

$i=2;
while(@tests) {
	$a = shift @tests;
	$b = shift @tests;
	print "#$i:\t$a\t<\t$b\n";
	if(versions != -1) {
		print "not ";
	}
	print "ok $i\n";
	$i++;
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
