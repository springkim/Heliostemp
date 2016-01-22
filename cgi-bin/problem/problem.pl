#!/usr/bin/perl
#
#	@Project : Helios
#	@Architecture : KimBom
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
if(!$pr_path){
	$pr_path="NULL";	
}
print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/problem_list.css" />
	<script src="javascript/problem_list.js" type="text/javascript"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<p style="color:#ffffff">$pr_path</p>
</body>
</html>
EOF
;