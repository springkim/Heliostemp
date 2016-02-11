#!/usr/bin/perl
use strict;
use warnings;
use DBI;
require 'info.pl';
my $con=DBI->connect(GetDB(),GetUserName(),GetPassword());

sub DropTable($){
	my $data=shift;
	my @table= $data=~/create table ([[:alpha:]|_|\d]*)/g;
	my $query="drop table ";
	my $in;
	for(my $i=$#table;$i>=0;$i--){
		$con->do($query.$table[$i]);
	}
}
sub CreateTable($){
	my $data=shift;
	my @query=$data =~/([^;]*)/g;
	my $in;
	foreach $in(@query){
		$con->do($in);
	}
}
sub DeleteUserPhoto(){
	system("rm ../login/photo/*");	
}
open(TEXT,"<table.txt") || die $!;
$/=undef;
my $data=<TEXT>;

DropTable($data);
#DeleteUserPhoto();
CreateTable($data);


#my $query="SELECT * FROM userinfo";
#my $state=$con->prepare($query);
#$state->execute();
#while(my @row = $state->fetchrow_array){
#	foreach my $i (@row) {
#		print $i." ";
#	}
#	print "\n";
#}
#$state->finish();


close(TEXT);
$con->disconnect;

