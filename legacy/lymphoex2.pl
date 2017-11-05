#!usr/bin/perl -w
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

if ( scalar ( @inp > 2 ) ) {
	open ( IN, "<", $inp[2] ) or die "Unable to open $inp[2] for reading :$!";
	@THR = <IN>;
	close IN or die "Unable to close $inp[2]: $!";
};

#if ( scalar ( @inp > 3 ) ) {
#	open ( IN, "<", $inp[3] ) or die "Unable to open $inp[3] for reading :$!";
#	@FOUR = <IN>;
#	close IN or die "Unable to close $inp[3]: $!";
#};

#if ( scalar ( @inp > 4 ) ) {
#	open ( IN, "<", $inp[4] ) or die "Unable to open $inp[4] for reading :$!";
#	@FIVE = <IN>;
#	close IN or die "Unable to close $inp[4]: $!";
#};

my %one = map {$_ => 1} @ONE;
my %two = map {$_ => 1} @TWO;
#my %thr = map {$_ => 1} @THR;
#my %four = map {$_ => 1} @FOUR;
#my %five = map {$_ => 1} @FIVE;

my @ONETWO = grep( $two{$_}, @ONE );
my @ONEuTWO = grep( !defined $two{$_}, @ONE );
my @TWOuONE = grep( !defined $one{$_}, @TWO );

#my @ONETHR = grep( $thr{$_}, @ONE );
#my @ONEuTHR = grep( !defined $thr{$_}, @ONE );
#my @ONEFOUR = grep( $four{$_}, @ONE );
#my @ONEuFOUR = grep( !defined $four{$_}, @ONE );
#my @ONEFIVE = grep( $five{$_}, @ONE );
#my @ONEuFIVE = grep( !defined $five{$_}, @ONE );


#my %onetwo = map {$_ => 1} @ONETWO;
#my %onethr = map {$_ => 1} @ONETHR;
#my %onefour = map {$_ => 1} @ONEFOUR;
#my %onefive = map {$_ => 1} @ONEFIVE;


#my @ONETWOTHR = grep( $onethr{$_}, @ONETWO );
#my @ONEFOURFIVE = grep( $onefive{$_}, @ONEFOUR);

#my %onetwothr = map {$_ => 1} @ONETWOTHR;

#my @ALL = grep( $onetwothr{$_}, @ONEFOURFIVE );
#my @ALL = grep( $onetwothr{$_}, @ONEFOUR );

#my $lot = scalar( @ONETWO );
#print "$lot\n";
#print "@ONETWO\n";
#my $lou = scalar( @ONEunique );
#print "$lou\n";

my $lot = scalar( @ONETWO );
my $lout = scalar( @ONEuTWO );
my $ltuo = scalar( @TWOuONE );
print "$lot\_$lout\_$ltuo\n";
chomp @ONETWO;
#print "@ONETWOTHR\n";

# manipulate intersection array to fit  
my (@splitline, @genecodes);
my @t12 = @ONETWO;

while ( scalar( @t12 > 0 ) ) {
	$_ = shift @t12;
	@splitline = split( /\s+/, $_);
	$_ = $splitline[0];
	push @genecodes, $_;
};

# file input, check argument length and
print my $finreq = "Please provide a single uorf data file for comparison to the analyzed microarray data.\n";
my $usrfin = <STDIN>;
my @ufi = split ( ' ', $usrfin );
die "Too many entries, please provide only one.\n" if ( scalar ( @ufi !=1 ) );
$usrfin = shift @ufi;

# read file, put data into array/hash for comparisons
open ( DATA , "<", $usrfin ) or die "Unable to open $usrfin for reading: $!";
my $UORFIN = <DATA>;
close DATA or die "Unable to close $usrfin: $!";
my @uorfs_raw = split( ' ', $UORFIN );
my %rawuorfs = map{ $_ => 1 } @uorfs_raw;

# compare intersecting microarray data with genes with strong kozaks in their uorfs
my @targets = grep( $rawuorfs{$_}, @genecodes );
my $tl = scalar(@targets);
print "$tl\n";



# open output file for writing
print "Please provide a single, empty .txt file for output.\n";
my $usrfio = <STDIN>;
my @ufo = split ( ' ', $usrfio );
die "Too many entries, please provide only one.\n" if ( scalar ( @ufo !=1 ) );
$usrfio = shift @ufo;
die "This file does not have a .TXT extension.\n" if ( $usrfio !~ /.txt/ );
open ( TXT, ">", $usrfio ) or die "Unable to open $usrfio for reading: $!";

# print to file, close file
print TXT "@targets\n";
close TXT or die "Unable to close $usrfio: $!";