#!/perl64/bin/perl -w
use strict;
use DBI;
use List::MoreUtils qw( each_array );

my $dbh = DBI->connect(
	'DBI:mysql:database=utrs;host=localhost:5432',
	'root',
	'megamanx',
	{ RaiseError => 1, AutoCommit => 1 },
);

# decl for loops

my $tempseq;
my @seq;
my @lines;
my %FASTA;
my @orfs;
my $count;
my @tid;
my @id;
my @ac;

# connect to the database



# file input, check argument length and for .fasta
print my $finreq = "Please provide a single .fasta file.\n";
my $usrfin = <STDIN>;
my @ufi = split ( ' ', $usrfin );
die "Too many entries, please provide only one.\n" if ( scalar ( @ufi > 1 ) );
$usrfin = shift @ufi;
die "This file does not have a .fasta extension.\n" if ( $usrfin !~ /.fasta/ );

# read file
open ( FASTA, "<", $usrfin ) or die "Unable to open $usrfin for reading: $!";
my @FASTAin = <FASTA>;
close FASTA or die "Unable to close $usrfin: $!";

while ( scalar( @FASTAin != 0) ) {
	$_ = shift @FASTAin;
	chomp $_;
	$_ =~ s/>//;
	
# id lines
	if ( $_ =~ /5HS/ ) {
		@tid = split( / /, $_);
		$_ = pop @tid;
		push @ac, $_;
		$_ = pop @tid;
		push @id, $_;
	
	$tempseq = join( '', @lines );
	if ( scalar ( @lines != 0 ) ) {
		push @seq, $tempseq;
		#print "$tempseq\n";
		#$_ = length($tempseq);
		#print "$_\n";
	}
	@lines = ();
	};
	
# process seq lines
	if ($_ !~ /5HS/) {
		print "$_\n";
		push @lines, $_;
	};	
};

# process last seq
$tempseq = join( '', @lines );
push @seq, $tempseq;
print "@ac\n";
print "@seq\n";

# MySQL - prep the INSERT statement once
#my $sth_insert = $dbh->prepare( 'INSERT INTO utr_seqs SET utr_ac=?, utr_id=?, seq=?' )
#	or die $dbh->errstr;
	
# create the array iterator
#my $ea = each_array(@ac, @id, @seq);

# iterate over all three arrays step by step
#while ( my ( $val_ac, $val_id, $val_seq ) = $ea ->() ) {
#	$sth_insert->execute( $val_ac, $val_id, $val_seq ) or die $dbh->errstr;
#};

