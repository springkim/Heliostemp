#!/usr/bin/perl
#
#	@Project : Helios
#	@Architecture : KimBom
#	@engeneer : HwangDaeHyeon
#	problem.pl
#
#	@Created by On 2016. 01. 23...
#	@Copyright (C) 2016 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
require "../login/info.pl";
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );


my $pr_path=$q->param('PR_PATH');
my $query="";
my $state;
#$pr_path="problem/problem_list/d0001.html";
my $problem_html;
if(!$pr_path){
	$pr_path="NULL";	
}else{
	#get database data
	$query="SELECT * from problem WHERE pr_path=\'$pr_path\'";
	$state=$con->prepare($query);
	$state->execute;
	my @row=$state->fetchrow_hashref;
		
	
	#########################################read selected problem
	$pr_path =~ /problem\/(.*)/;
	open(FIN,"<$1") or die $!;
	$/=undef;
	$problem_html=<FIN>;
	
	
	
	close(FIN);	
}


print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/problem.css" />
	<script src="javascript/problem.js" type="text/javascript"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	
	<div class="left_side">
	<p style="color:#ffffff">$pr_path</p>
	</div>
EOF
;
print <<EOF
	<div class=main_side>
	
	</div>
</body>
</html>
EOF
;

