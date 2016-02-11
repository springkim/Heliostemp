#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use MIME::Lite;
require 'info.pl';
my $file_str="";
sub print_header() {
	$file_str=$file_str.'#!/usr/bin/perl' . "\n";
	$file_str=$file_str.'use strict;' . "\n";
	$file_str=$file_str.'use warnings;' . "\n";
	$file_str=$file_str.'use DBI;' . "\n";
	$file_str=$file_str.'require \'info.pl\';' . "\n";
	$file_str=$file_str.'my $con = DBI->connect( GetDB(), GetUserName(), GetPassword() );'
	  . "\n";
}

sub print_end() {
	$file_str=$file_str.'$con->disconnect;' . "\n";
}

sub execute($$) {
	my $con   = DBI->connect( GetDB(), GetUserName(), GetPassword() );
	my $query = shift;
	my $table = shift;
	my $state = $con->prepare($query);
	$state->execute();
	while ( my @row = $state->fetchrow_array ) {
		$file_str=$file_str.'$con->do("INSERT INTO ' . $table . " VALUES(";
		my $str = "";
		foreach my $i (@row) {
			$str = $str . "\'" . $i . "\',";
		}
		chop $str;
		$str =~ s/\@/\\@/g;
		$file_str=$file_str.$str;
		$file_str=$file_str.")\");\n";
	}
	$state->finish();
	$con->disconnect;
}

sub SaveDatabase() {
	open( TEXT, "<table.txt" ) || die $!;
	$/ = undef;
	my $data = <TEXT>;
	my @table = $data =~ /create table ([[:alpha:]|_|\d]*)/g;
	my $in;
	foreach $in (@table) {
		my $query = "SELECT * FROM $in";
		execute( $query, $in );
	}
}

sub SaveFile() {
	my $max_date = 3;
	opendir( DIR, "recovery" ) || die print $!;
	my @files = readdir(DIR);
	@files=sort @files;
	shift @files;	#remove .
	shift @files;	#remove ..
	shift @files;	#remove info.pl
	if($#files>=3-1){
		system "rm recovery/".$files[0];
	}
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
	my $date=($year+1900)."_".($mon+1)."_".$mday."_".$hour."_".$min."_".$sec;
	my $file_name="recovery/r".$date.".pl";
	open FP,">",$file_name;
	print FP $file_str;
	close FP;
	my $msg = MIME::Lite->new(
    'Return-Path' => 'bluecandle@bluecandle.me',
    'From'        => 'bluecandle@bluecandle.me',
    'To'          => 'helioscandle@gmail.com',
    'Subject'     => $date,
    'Charset'     => 'utf-8',
    'Encoding'    => '8bit',
    'Data'        => 'helios database recovery file'
    );
	$msg->attach(
        Type     => 'file',
        Path     => $file_name,
        Filename => $file_name,
        Disposition => 'attachment'
    );
	$msg->send;
}

#===============
if($>){
	print "Use in root permission\n";
	die;	
}
print_header;
SaveDatabase();
print_end;
SaveFile();
