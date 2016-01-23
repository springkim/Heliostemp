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
#=======left side print 요소

my $time_limit;
my $mem_limit;
my $tried_count;
my $solved_count;
my $rate; 
#======

my $pr_path=$q->param('PR_PATH');
my $query="";
my $state;
	my $style="";
my $problem="";
$pr_path="problem/problem_list/d0001.html";
my $problem_html;
if(!$pr_path){
	$pr_path="NULL";	
}else{
	#get database data
	$query="SELECT * from problem WHERE pr_path=\'$pr_path\'";
	$state=$con->prepare($query);
	$state->execute;

	my $row=$state->fetchrow_hashref;
	$time_limit=$row->{pr_timelimit};
	$mem_limit=$row->{pr_memlimit};
	
	$query="SELECT COUNT(pr_path) FROM userinfo_problem WHERE pr_path=\'$pr_path\'";
	$state = $con->prepare($query);
	$state ->execute;
	my @arr = $state->fetchrow_array;
	$tried_count = $arr[0];
	$query="SELECT COUNT(ui_id) FROM userinfo_problem WHERE pr_path=\'$pr_path\' AND uip_status = \'accepted\'";
	$state = $con->prepare($query);
	$state ->execute;
	@arr = $state->fetchrow_array;
	$solved_count = $arr[0];
	$rate =0;
	if(!($tried_count==0 && $tried_count eq "0")){
	$rate =$solved_count/$tried_count*100;
	}
	#########################################read selected problem

	$pr_path =~ /problem\/(.*)/;
	open(FIN,"<$1") or die $!;
	$/=undef;
	$problem_html=<FIN>;
	$problem_html =~ /<style>(.*)<\/style>/;
	$style=$1;
	$problem_html =~ /<\/head>(.*)<\/html>/s;
	$problem=$1;
	$problem =~ s/<body/<div style="background-color:rgba(0,0,0,0);color:#ffffff"/;
	$problem =~ s/<\/body>/<\/div>/;
	
	$problem_html=~ /HIDDEN:::(.*):::/;
	$problem=~ s/HIDDEN:::$1::://;
	
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
	<style>$style></style>
</head>
<body>
	
	<div class="left_side">
		<div class=left_side_1>
			<div class=left_side_1_1>
			<p>PROBLEM</p>
			
			</div>
			<div class=left_side_1_2>
				<div class=left_side_1_2_1>
				</div>
			</div>
		</div>
		<div class=left_side_2>
			<p>Time Limit : $time_limit sec Space Limit : $mem_limit Mb</p>
		</div>
		<div class=left_side_3>
			<p>Tried : $tried_count Solved : $solved_count (Rate: $rate %)</p>
		</div>
		
	</div>
EOF
;
print <<EOF
	<div class=main_side>
		<div class=main_top>
		</div>
		<div class=main_problem>
		$problem
		</div>
	</div>
</body>
</html>
EOF
;

