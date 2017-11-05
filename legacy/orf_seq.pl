#!/Perl64/bin/perl -w
use strict;

# declarations
my (
	$tgene, @tg, @uorfgenes,
	@tseq, @koz_cs, $kozc, $c,
	@stkozgenes, $seq, $t, $ts,
);

my %stops = (
	"tga" => 1, "taa" => 1, "tag" => 1,
);

# file input, check argument length and for .fasta
print my $finreq = "Please provide a single .fasta file.\n";
my $usrfin = <STDIN>;
my @ufi = split ( ' ', $usrfin );
die "Too many entries, please provide only one.\n" if ( scalar ( @ufi !=1 ) );
$usrfin = shift @ufi;
die "This file does not have a .fasta extension.\n" if ( $usrfin !~ /.fasta/ );

# read file
open ( FASTA, "<", $usrfin ) or die "Unable to open $usrfin for reading: $!";
my @FASTAin = <FASTA>;
close FASTA or die "Unable to close $usrfin: $!";

# open output file for writing
print "Please provide a single, empty .txt file for output.\n";
my $usrfio = <STDIN>;
my @ufo = split ( ' ', $usrfio );
die "Too many entries, please provide only one.\n" if ( scalar ( @ufo !=1 ) );
$usrfio = shift @ufo;
die "This file does not have a .txt extension.\n" if ( $usrfio !~ /.txt/ );
open ( TXT, ">", $usrfio ) or die "Unable to open $usrfio for reading: $!";


# process file
while ( scalar( @FASTAin != 0) ) {
	$_ = shift @FASTAin;
	chomp $_;
	
# pull alphanumerical gene names from parantheses
	if ( $_ =~ /\((.+)\)/g ) {
		@tg = split( ' ', $1);
		$tgene = pop @tg;	
		$tgene =~ s/[\(\)]//g;	

	};	
	if ( $_ =~ /[ag]..atgg/ ) {
		$ts = $_;
#		until ($t !~ /atg/) {
		if ($ts =~ /([ag]..atgg[actg]+)/) {
			@tseq = split(/([actg]{3})/, $1);
			};
		foreach ( @tseq ) { 
			if (exists $stops{$_} ) {
				unless ( grep { $_ eq $tgene } @stkozgenes ) {
					push @stkozgenes, $tgene;
				};
			};
		};
	};	
};

print TXT "@stkozgenes\n";
#print CSV "@koz_cs\n";
my $l = scalar(@stkozgenes);
print "$l\n";

close TXT or die "Unable to close $usrfio: $!";