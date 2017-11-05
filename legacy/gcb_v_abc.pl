#!Perl64/bin/perl -w
use strict;

# declarations
my (	
	@tmp, @ONE, @TWO, @THR, @FOUR, @FIVE
);

# file input, check argument length
print "Please provide one to three text files of expression data for expression pattern comparisons:\n";
my $in = <STDIN>;
my @inp = split( ' ', $in );
die "Not enough entries, please provide at least one.\n" if ( scalar ( @inp == 0 ) );
die "Too many entries, please provide no more than three.\n" if ( scalar ( @inp > 3 ) );

# read file(s)
open ( IN, "<", $inp[0] ) or die "Unable to open $inp[0] for reading: $!";
@ONE = <IN>;
close IN or die "Unable to close $inp[0]: $!";

if ( scalar ( @inp > 1 ) ) {
	open ( IN, "<", $inp[1] ) or die "Unable to open $inp[1] for reading :$!";
	@TWO = <IN>;
	close IN or die "Unable to close $inp[1]: $!";
};
	
my %one = map {$_ => 1} @ONE;
my %two = map {$_ => 1} @TWO;
my @ONETWO = grep( $two{$_}, @ONE );
my $lot = scalar(@ONETWO);
my @ONEuTWO = grep( !defined $two{$_}, @ONE );
my $lout = scalar(@ONEuTWO);
my @TWOuONE = grep( !defined $one{$_}, @TWO );
my $ltuo = scalar(@TWOuONE);

print "$lot\n$lout\n$ltuo";