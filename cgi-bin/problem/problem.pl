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
my $rank_html=""; 
my @rank;
my @rank_id;
my @rank_lang;
my @rank_time;
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
	#get tried count
	$query="SELECT COUNT(pr_path) FROM userinfo_problem WHERE pr_path=\'$pr_path\'";
	$state = $con->prepare($query);
	$state ->execute;
	my @arr = $state->fetchrow_array;
	$tried_count = $arr[0];
	#get solve count
	$query="SELECT COUNT(ui_id) FROM userinfo_problem WHERE pr_path=\'$pr_path\' AND uip_status = \'accepted\'";
	$state = $con->prepare($query);
	$state ->execute;
	@arr = $state->fetchrow_array;
	$solved_count = $arr[0];
	$rate =0;
	if(!($tried_count==0 && $tried_count eq "0")){
		$rate =$solved_count/$tried_count*100;
	}
	#get rank
	$query="SELECT * FROM userinfo_problem WHERE pr_path=\'$pr_path\' AND uip_status = \'accepted\' ORDER BY uip_time";
	$state = $con->prepare($query);
	$state -> execute;
	
	my $state_temp;
	my $rank_temp;
	my $loop_cnt=0;
	while($row = $state->fetchrow_hashref){
		$state_temp= $con->prepare("SELECT ui_name FROM userinfo WHERE ui_id=\'$row->{ui_id}\'");
		$state_temp->execute;
		my @rank_name = $state_temp->fetchrow_array;
		#$rank_temp = $rank_name[0]." ".$row->{uip_language}." ".$row->{uip_time};
		push @rank_id ,$rank_name[0];
		push @rank_lang , $row->{uip_language};
		push @rank_time , $row->{uip_time};
		$state_temp->finish;
		$loop_cnt++;
		if($loop_cnt==9){
			last;
		}
		
	}
	$state->finish;
		
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
################################# print rank html ####################
	for(my $i = 0 ; $i<=$#rank_id; $i++){
		my $font_size =12;
		my $font_color = "#EAEAEA";
		if($i==0){
			$font_color ="#FFD6EC";
		}
		elsif($i==1){
			$font_color ="#D4F4FA";
		}
		elsif($i==2){
			$font_color ="#DAD9FF";
		}
		$rank_html= $rank_html."<tr style=\"color:".$font_color."\">"."<th>".($i+1)."</th>"."<td>".$rank_id[$i]."</td>"."<td>".$rank_lang[$i]."</td>"."<td>".$rank_time[$i]."</td>"."</tr>";
	}
#################################	
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
				<img src="../image/problem.png" width="40px", height="40px" style="position:absolute;top:-10px; left:-50px;">
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
		<div class=left_side_4>
			<p>RANKING</p>
				<table class="type07">  
	          		<tbody>
	          			<tr style="background-color: rgba(96, 190, 204, 0.5)"><th>Rank</th><td>Name</td><td>Language</td><td>Time</td></tr>
	          			$rank_html
	              </tbody>
              </table>		
		</div>
		<div class=left_side_5>
			<div class="button" onclick="location.href='problem_list.pl';">
					Submit Your Problem
			</div>
		</div>
		<div class=left_side_6>
			<div class="button" onclick="location.href='problem_list.pl';">
					Click This -> Go to problem_list
			</div>
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


