#!/perl64/bin/perl -w
use strict;
use DBI;
use List::MoreUtils qw( each_array );

# connect to the database

my $dbh = DBI->connect(
	'DBI:mysql:database=utrs;host=localhost:5432',
	#'user',
	#'pw',
	{ RaiseError => 1, AutoCommit => 1 },
);

# declarations

# count scalars for nucleotides at any given position, integer scalars
my ($as, $ts, $gs, $cs, $i, $j);

# general scalars/arrays used through the code
my ($seq, @lines, @tid, @ac, $tac,
	@kozak_seqs, $tsq, $count, @s);

# super-array for whole atg-enclosing seq and sub-arrays for nucleotides at a given 
# relevant position in the atg-enclosing sequence, 7/8/9 refer to the atg enclosed
my (@kozak_nuc_str, @k1, @k2, 
	@k3, @k4, @k5, @k6, @k7, 
	@k8, @k9, @k10, @k11, @k12);

# ref scalars for deref'd position arrays	
my ($kbref1, $kbref2, $kbref3, $kbref4, 
	$kbref5, $kbref6, $kbref7, $kbref8, 
	$kbref9, $kbref10, $kbref11, $kbref12
) = (
	\@k1, \@k2, \@k3, \@k4, \@k5, \@k6, 
	\@k7, \@k8, \@k9, \@k10, \@k11, \@k12);
	
my @kozak_nucs = ( 
	$kbref1, $kbref2, $kbref3, $kbref4, 
	$kbref5, $kbref6, $kbref7, $kbref8, 
	$kbref9, $kbref10, $kbref11, $kbref12);

my @pos = ("-6", "-5", "-4", "-3", 
		   "-2", "-1", "+1", "+2", 
		   "+3", "+4", "+5", "+6");
		   
my (@a, @t, @g, @c);
my ($aref, $tref, $gref, $cref) = (\@a, \@t, \@g, \@c);

my @freq_array = ($aref, $tref, $gref, $cref);

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


# process file
while ( scalar( @FASTAin != 0) ) {
	$_ = shift @FASTAin;
	chomp $_;

# id lines
	if ( $_ !~ /[=>]/ ) {

		$seq = $_;
		$count = $seq =~ s/atg/atg/g;
		
		while ($count >= 1) {

# isolate kozak from sequence, split into individual nucs
		if ($seq =~ /(\w\w\w\w\w\watg\w\w\w)/){
			@s = split(//, $1);
		};		
# push nucleotides into AoA based on sequence order
			while (scalar(@s != 0)) {
				for $j (0 .. 11) {
					$tsq = shift @s;
					push @{$kozak_nucs[$j]}, $tsq;
				};
			};
			
# convert copied atg into 123
			$seq =~ s/atg/123/;
			$count = $seq =~ s/atg/atg/g;
			
		};
		@lines = ();
		@tid = split( / /, $_);
		$tac = pop @tid;
	};

};

# process last seq
$seq = $_;
$count = $seq =~ s/atg/atg/g;
		
while ($count >= 1) {

# isolate kozak from sequence, split into individual nucs
		if ($seq =~ /(\w\w\w\w\w\watg\w\w\w)/){
			@s = split(//, $1);
		};
# push nucleotides into AoA based on sequence order
	while (scalar(@s != 0)) {
		for $j (0 .. 11) {
			$tsq = shift @s;
			push @{$kozak_nucs[$j]}, $tsq;
		};
	};
			
# convert copied atg into 123
	$seq =~ s/atg/123/;
	$count = $seq =~ s/atg/atg/g;		
};

# concatentate sequence position nucleotide arrays into scalars
for $i (0 .. 11) {
	$_ = join("", @{$kozak_nucs[$i]});
	$kozak_nuc_str[$i] = $_;
print "$kozak_nuc_str[$i]\n";
};

for $i (0 .. 11) {
	$kozak_nuc_str[$i] =~ s/1/a/g;
	$kozak_nuc_str[$i] =~ s/2/t/g;
	$kozak_nuc_str[$i] =~ s/3/g/g;
};

# generate positional nucleotide frequence array
for $i (0 .. 11) {
	@{$kozak_nucs[$i]} = ();
	$as = ($kozak_nuc_str[$i] =~ s/a/a/g);
	$as = $as +1;
	push @{$kozak_nucs[$i]}, $as;
	$ts = ($kozak_nuc_str[$i] =~ s/t/t/g);
	$ts = $ts +1;
	push @{$kozak_nucs[$i]}, $ts;
	$gs = ($kozak_nuc_str[$i] =~ s/g/g/g);
	$gs = $gs +1;
	push @{$kozak_nucs[$i]}, $gs;
	$cs = ($kozak_nuc_str[$i] =~ s/c/c/g);
	$cs = $cs +1;
	push @{$kozak_nucs[$i]}, $cs;
};

for $i (0 .. 11) {
	$_ = join(";", @{$kozak_nucs[$i]});
	$kozak_nuc_str[$i] = $_;
};

#print results to screen for validation, redundant but satisfies instant gratification
print "@kozak_nuc_str\n";

# ARRAY FORMAT - POS 1: A's/T's/G's/C's, POS 2: SAME, POS 3: SAME, etc...

# MySQL - prep the INSERT statement once
my $sth_insert = $dbh->prepare( 'INSERT INTO utr_koznucfreq SET seq_pos=?, nuc_insts=?' )
	or die $dbh->errstr;
		
# create the array iterator
my $ea = each_array(@pos, @kozak_nuc_str);

# iterate over all three arrays step by step
while ( my ( $val_pos, $val_kozak_nuc_str ) = $ea ->() ) {
	$sth_insert->execute( $val_pos, $val_kozak_nuc_str ) or die $dbh->errstr;
};
