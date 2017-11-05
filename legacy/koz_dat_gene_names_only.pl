#!/usr/bin/perl -w
use strict;
#use DBI;
use List::MoreUtils qw( each_array );

# connect to the database

#my $dbh = DBI->connect(
#	'DBI:mysql:database=utrs;host=localhost:5432',
#	'root',
#	'megamanx',
#	{ RaiseError => 1, AutoCommit => 1 },
#);

# declarations
my ($seq, @lines, @tid, @ac, $tac, @ts, $i,
	@de, $tde, @tseq, @tuind, @uorfindex,
	@tuorfbases, $tuorf, $tgene, 
	@kozak_seqs, $tsq, $count, @tg, @genes );
	
# file input, check argument length and for .dat
print "Please provide a single .dat file for input.\n";
my $usrfin = <STDIN>;
my @ufi = split ( ' ', $usrfin );
die "Too many entries, please provide only one.\n" if ( scalar ( @ufi !=1 ) );
$usrfin = shift @ufi;
die "This file does not have a .dat extension.\n" if ( $usrfin !~ /.dat/ );

# read file
open ( DAT, "<", $usrfin ) or die "Unable to open $usrfin for reading: $!";
my @DATin = <DAT>;
close DAT or die "Unable to close $usrfin: $!";

# open output file for writing
#print "Please provide a single, empty .fasta file for output.\n";
#my $usrfio = <STDIN>;
#my @ufo = split ( ' ', $usrfio );
#die "Too many entries, please provide only one.\n" if ( scalar ( @ufo !=1 ) );
#$usrfio = shift @ufo;
#die "This file does not have a .fasta extension.\n" if ( $usrfio !~ /.fasta/ );
#open ( FASTA, ">", $usrfio ) or die "Unable to open $usrfio for reading: $!";


# process file
while ( scalar( @DATin != 0) ) {
	$_ = shift @DATin;

# accession code
#	if ( $_ =~ /AC\s{3}/ ) {
#		$_ =~ s/AC\s{3}//;
#		$_ =~ s/;//;
#		chomp $_;
#		$tac = $_;
#		@de = ();
#		@ts = ();
#		@tseq = ();
#	};

# mRNA/gene identity	
	if ( $_ =~ /DE\s{3}/ ) {
		$_ =~ s/DE\s{3}//;
		$_ =~ s/\.//;
		chomp $_;
		push @de, $_;
	};
	
	if ( $de[0] =~ /\((.+)\)/g ) {
	print "$1\n";
		@tg = split( ' ', $1);
	#	$tgene = pop @tg;	
		#$tgene =~ s/[\(\)]//g;	
	#	@de = ();
		#unless ( grep $_ eq $tgene, @genes ) {
		#		push @genes, $tgene;
		#};
	};	

	

# when a uORF is present... index the start/end nucleotides, the relevant AC and gene name
#	if ( $_ =~ /FT\s{3}uORF/ ) {
#		$_ =~ s/FT\s{3}uORF\s{12}//;
#		@tuind = split (/\.{2}/);
#		@tuind = map {$_ - 1} @tuind;
#		$tde = join (' ', @de);
#		chomp $tde;
#		print "$tac\n";
#		print "$tde\n";
#		print "@tuind\n";
#		push @uorfindex, (shift @tuind);
#		push @uorfindex, (shift @tuind);
#	};

# pull sequence
#	if ( $_ =~ /\s{4,}/ && scalar( @uorfindex != 0 ) && $_ !~ /[ODRFHSQX\/]/ ) {
#		$_ =~ s/[\s\d]//g;
#		chomp $_;
#		push @ts, $_;
#		$tsq = join ('', @ts);
#	};	
#	if ( $_ =~ /\/\// && scalar ( @uorfindex != 0 ) ) {
#		@tseq = split ('', $tsq); 
#		print "@tseq\n";
#		while ( scalar( @uorfindex != 0 ) ) {
#			$i = $uorfindex[0]-9;
#			print "$i\n";
#			until ( $i == $uorfindex[1] ) {
#				print "$i\n";
#				push @tuorfbases, $tseq[$i];
#				$i = $i + 1;
#			};
#			print "$i\n";
#			push @tuorfbases, $tseq[$i];
#			$tuorf = join ('', @tuorfbases);
#			print FASTA ">$tac\n";
#			print FASTA ">$tde\n";
#			print "@tuind\n"; 
#			print FASTA "$tuorf\n";	
#			shift @uorfindex;
#			shift @uorfindex;
#			@tuorfbases = ();
#		};
#		@uorfindex = ();
#	};		
};

my $l = scalar(@genes);
print "$l\n";

#print "@uorfindex\n";

#close FASTA or die "Unable to close $usrfio: $!";


# process last seq
#$seq = join( '', @lines );
#$count = $seq =~ s/atg/atg/g;
#while ($count >= 1) {
# isolate kozak from sequence, split into individual nucs
#	$seq =~ /(\w\w\w\w\w\watg\w\w\w)/;
#	print "$tac\n";
#	push @ac, $tac;
#	print "$1\n";
#	if ($1 ne "") {
#				push @kozak_seqs, $1;
#	};
#	my @s = split(//, $1);
			
# push nucleotides into AoA based on sequence order
#	while (scalar(@s != 0)) {
#		for $j (0 .. 11) {
#			$tsq = shift @s;
#			push @{$kozak_nucs[$j]}, $tsq;
#		};
#	};
			
# convert copied atg into 123
#	$seq =~ s/atg/123/;
#	$count = $seq =~ s/atg/atg/g;		
#};