use ExtUtils::MakeMaker;
use Carp;

# $Id: Makefile.PL,v 1.4 2003/08/24 22:43:19 ed Exp $

&WriteMakefile(
	NAME => 'Sort::Versions',
	VERSION_FROM => 'Versions.pm',
);
