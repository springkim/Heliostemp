#!/usr/bin/perl
#
#	@Project : Helios
#	@Architecture : KimBom
#	problem_list.pl
#
#	@Created by On 2016. 01. 22...
#	@Copyright (C) 2016 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
require "../login/info.pl";
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );


print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/problem_list.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<div class=left_side>
	
	</div>
	<div class=main_side>
	
	</div>
</body>
</html>
EOF
;