#!/Perl64/bin/perl -w
use strict;


print my $finreq = "Please provide a single file.\n";
my $usrfin = <STDIN>;
my @ufi = split ( ' ', $usrfin );
die "Too many entries, please provide only one.\n" if ( scalar ( @ufi !=1 ) );
$usrfin = shift @ufi;


open ( FASTA, "<", $usrfin ) or die "Unable to open $usrfin for reading: $!";
my @in = <FASTA>;
close FASTA or die "Unable to close $usrfin: $!";
my (@genecodes, @splitline);

while ( scalar( @in > 0 ) ) {
	$_ = shift @in;
	@splitline = split( /\s+/, $_);
	$_ = $splitline[0];
	push @genecodes, $_;
};
print "@genecodes\n";