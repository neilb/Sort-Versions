#!/usr/bin/perl

# $Id: Versions.pm,v 1.4 2002/01/28 19:06:34 epa98 Exp $

# Copyright (c) 1996, Kenneth J. Albanowski. All rights reserved.  This
# program is free software; you can redistribute it and/or modify it under
# the same terms as Perl itself.

package Sort::Versions;
use vars '$VERSION';
$VERSION = '1.3';

require Exporter;
@ISA=qw(Exporter);

@EXPORT=qw(&versions &versioncmp);
@EXPORT_OK=qw();

sub versions {
    my(@A) = ($::a =~ /([-.]|\d+|[^-.\d]+)/g);
    my(@B) = ($::b =~ /([-.]|\d+|[^-.\d]+)/g);
    my($A,$B);
    while (@A and @B) {
	$A=shift @A;
	$B=shift @B;
	if ($A eq "-" and $B eq "-") {
	    next;
	} elsif ( $A eq "-" ) {
	    return -1;
	} elsif ( $B eq "-") {
	    return 1;
	} elsif ($A eq "." and $B eq ".") {
	    next;
	} elsif ( $A eq "." ) {
	    return -1;
	} elsif ( $B eq "." ) {
	    return 1;
	} elsif ($A =~ /^\d+$/ and $B =~ /^\d+$/) {
	    if ($A =~ /^0/ || $B =~ /^0/) {
		return $A cmp $B if $A cmp $B;
	    } else {
		return $A <=> $B if $A <=> $B;
	    }
	} else {
	    $A = uc $A;
	    $B = uc $B;
	    return $A cmp $B if $A cmp $B;
	}	
    }
    @A <=> @B;
}

sub versioncmp {
	local($::a,$::b)=@_;
	versions;
}

=head1 NAME

Sort::Versions - a perl 5 module for sorting of revision-like numbers

=head1 SYNOPSIS

	use Sort::Versions;
	@l = sort versions qw( 1.2 1.2.0 1.2a.0 1.2.a 1.a 02.a );

	...

	use Sort::Versions;
	print "lower" if versioncmp("1.2","1.2a")==-1;
	
	...
	
	use Sort::Versions;
	%h = (1 => "d", 2 => "c", 3 => "b", 4 => "a");
	@h = sort {versioncmp $h{$a}, $h{$b}} keys %h;

=head1 DESCRIPTION	

Sort::Versions allows easy sorting of mixed non-numeric and numeric strings,
like the "version numbers" that many shared library systems and revision
control packages use. This is quite useful if you are trying to deal with
shared libraries. It can also be applied to applications that intersperse
variable-width numeric fields within text. Other applications can
undoubtedly be found.

For an explanation of the algorithm, itE<39>s simplest to look at these examples:

  1.1   <  1.2
  1.1a  <  1.2
  1.1   <  1.1.1
  1.1   <  1.1a
  1.1.a <  1.1a
  1     <  a
  a     <  b
  1     <  2
  1.1-3 <  1.1-4
  1.1-5 <  1.1.6

More precisely (but less comprehensibly), the two strings are treated
as subunits delimited by periods or hyphens. Each subunit can contain
any number of groups of digits or non-digits. If digit groups are
being compared on both sides, a numeric comparison is used, otherwise
a ASCII ordering is used. A group or subgroup with more units will win
if all comparisons are equal.  A period binds digit groups together
more tightly than a hyphen.

Some packages use a different style of version numbering: a simple
real number written as a decimal. Sort::Versions has limited support
for this style: when comparing two subunits which are both digit
groups, if either subunit has a leading zero, then both are treated
like digits after a decimal point. So for example:

  0002  <  1
  1.06  <  1.5

This wonE<39>t always work, because there wonE<39>t always be a leading zero
in real-number style version numbers. There is no way for
Sort::Versions to know which style was intended. But a lot of the time
it will do the right thing. If you are making up version numbers, the
style with (possibly) more than one dot is the style to use.

=head1 USAGE

Sort::Versions exports C<versions> and C<versioncmp>. The former is a
function suitable for handing directly to C<sort>. The second function,
C<versioncmp>, takes two arguments and returns a cmp style comparison value.
This is handy in indirect comparisons, as shown above.

=head1 AUTHOR

Kenneth J. Albanowski		kjahds@kjahds.com  (original author)
Ed Avis, Matt Johnson           {epa98,mwj99}@doc.ic.ac.uk (this release)
Hack Kampbjørn                  hack.kampbjorn@vigilante.com (hyphen patch)

Copyright (c) 1996, Kenneth J. Albanowski. All rights reserved.  This
program is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut

1;
__END__

#
# $Log: Versions.pm,v $
# Revision 1.4  2002/01/28 19:06:34  epa98
# Version 1.3: patch from Hack Kampbjørn for '-' digit groupings as well
# as '.'.
#
# Revision 1.3  2001/07/28 16:52:22  epa98
# Added $VERSION.
#
# Revision 1.2  2001/07/28 16:33:50  epa98
# Added support for numeric comparisons where one version number has a
# leading zero.
#
# Revision 1.3  1996/07/11 13:37:00  kjahds
# Added information on how to use versioncmp for indirect sort, and
# exported it by default. Version bumped to 1.1.
#
# Revision 1.2  1996/06/24 09:20:44  kjahds
# *** empty log message ***
#
# Revision 1.1.1.1  1996/06/24 09:06:18  kjahds
#
# Revision 1.4  1996/06/23 16:02:13  kjahds
# *** empty log message ***
#
# Revision 1.3  1996/06/23 15:59:50  kjahds
# *** empty log message ***
#
# Revision 1.2  1996/06/23 06:26:07  kjahds
# *** empty log message ***
#
# Revision 1.1.1.1  1996/06/23 06:07:48  kjahds
# import
#
#
