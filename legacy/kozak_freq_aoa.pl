#!/perl64/bin/perl -w
use strict;
use DBI;
use List::MoreUtils qw( each_array );

# connect to the database

my $dbh = DBI->connect(
	'DBI:mysql:database=utrs;host=localhost:5432',
	'root',
	'megamanx',
	{ RaiseError => 1, AutoCommit => 1 },
);

# declarations
my ($seq, @lines, @tid, @ac, $tac,
	@kozak_seqs, $tsq, $count);
	
my (@kozak_freq, @k1, @k2, 
	@k3, @k4, @k5, @k6, @k7, 
	@k8, @k9, @k10, @k11, @k12);
	
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

my ($pos, 
);
my ($a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $a10, $a11, $a12,
	$t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9, $t10, $t11, $t12, 
	$c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $c10, $c11, $c12,
	$g1, $g2, $g3, $g4, $g5, $g6, $g7, $g8, $g9, $g10, $g11, $g12
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


# process file
while ( scalar( @FASTAin != 0) ) {
	$_ = shift @FASTAin;
	chomp $_;

# id lines
	if ( $_ =~ /5HS/ ) {
		$_ =~ s/>//;
		@tid = ();
		$seq = join( '', @lines );
		$count = $seq =~ s/atg/atg/g;
		while ($count >= 1) {
# isolate kozak from sequence, split into individual nucs
			$seq =~ /(\w\w\w\w\w\watg\w\w\w)/;
			print "$tac\n";
			push @ac, $tac;
			print "$1\n";
			if ($1 ne "") {
				push @kozak_seqs, $1;
			};
#			my @s = split(//, $1);
			
# push nucleotides into AoA based on sequence order
#			while (scalar(@s != 0)) {
#				for my $j (0 .. 11) {
#					$tsq = shift @s;
#					push @{$kozak_nucs[$j]}, $tsq;
#				};
#			};
			
# convert copied atg into 123
			$seq =~ s/atg/123/;
			$count = $seq =~ s/atg/atg/g;
			
		};
		@lines = ();
		@tid = split( / /, $_);
		$tac = pop @tid;
	};
# process seq lines
	if ( $_ !~ /BA/ ) {
		push @lines, $_;
	};	
};

# process last seq
$seq = join( '', @lines );
$count = $seq =~ s/atg/atg/g;
while ($count >= 1) {
# isolate kozak from sequence, split into individual nucs
	$seq =~ /(\w\w\w\w\w\watg\w\w\w)/;
	print "$tac\n";
	push @ac, $tac;
	print "$1\n";
	if ($1 ne "") {
				push @kozak_seqs, $1;
	};
#	my @s = split(//, $1);
			
# push nucleotides into AoA based on sequence order
#	while (scalar(@s != 0)) {
#		for my $j (0 .. 11) {
#			$tsq = shift @s;
#			push @{$kozak_nucs[$j]}, $tsq;
#		};
#	};
			
# convert copied atg into 123
	$seq =~ s/atg/123/;
	$count = $seq =~ s/atg/atg/g;		
};

# concatentate sequence position nucleotide arrays into scalars


# MySQL - prep the INSERT statement once
my $sth_insert = $dbh->prepare( 'INSERT INTO utr_12bpotkoz SET utr_ac=?, 12b_pot_koz=?' )
	or die $dbh->errstr;
		
# create the array iterator
my $ea = each_array(@ac, @kozak_seqs);

# iterate over all three arrays step by step
while ( my ( $val_ac, $val_kozak_seqs ) = $ea ->() ) {
	$sth_insert->execute( $val_ac, $val_kozak_seqs ) or die $dbh->errstr;
};


