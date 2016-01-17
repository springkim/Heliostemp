#!/usr/bin/perl
use strict;
use warnings;
use DBI;
my $con=DBI->connect("dbi:Pg:dbname=postgres","postgres","kb6331");


$con->do("delete FROM userinfo_emblem");
$con->do("delete FROM emblem");

opendir(DIR, "../image/emblem") || die print $!;
my @files=readdir(DIR);
foreach my $elem(2..$#files){
	my $eb_path="image/emblem/".$files[$elem];
	$files[$elem]=~/([a-z]+)./g;
	my $eb_name=$1;
	my $query="INSERT INTO emblem VALUES(\'$eb_name\',\'$eb_path\')";
	$con->do($query);
}

$con->disconnect();
