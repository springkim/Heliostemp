#!/usr/bin/perl
use strict;
use warnings;
use DBI;
require 'info.pl';



my $con = DBI->connect( GetDB(), GetUserName(), GetPassword() );
	
$con->do("INSERT INTO userinfo_emblem VALUES(\'c\',\'root\')");	
	
$con->disconnect;
	
