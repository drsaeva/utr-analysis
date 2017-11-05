#!/Perl64/bin/perl -w
use strict;

# declarations
my (
	$tgene, @tg, @uorfgenes,
	@tseq, @koz_cs, $kozc, $c,
	@koz_genes, $seq, $t,
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
#		$c = () = $_ =~ /[ag]..atgg/g;
		unless ( grep { $_ eq $tgene } @koz_genes ) {
				push @koz_genes, $tgene;
		};
#		push @koz_cs, $c;
	};	
};

print TXT "@koz_genes\n";
#print CSV "@koz_cs\n";
my $l = scalar(@koz_genes);
print "$l\n";

close TXT or die "Unable to close $usrfio: $!";