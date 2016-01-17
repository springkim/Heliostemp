#!/usr/bin/perl
#
#	@Project  : Helios
#	@Architecture : DaeHyun, Hwang
#	signup.pl
#
#	@Created by On 2016. 1. 2...
#	@Copyright (C) 2016 DaeHyun, Hwang. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
use File::Copy;
use Time::Stamp 'gmstamp', 'parsegm';
require 'info.pl';

#==============================Ready for CGI.===================================
my $q=new CGI;
my $con=DBI->connect(GetDB(),GetID(),GetPW());

#==============================Recive 'Form' data.==============================

my $id=$q->param('ID');
my $pw=$q->param('EPW');
my $salt_temp=$q->param("SALT_TEMP");
#==============================================================
my $iv = "dGdW9dB94c0UFxBGDyC3b66EHg3uGApZ";
my $passPhrase = "ZWslYcAfub7RehxUlyvg3FpXXuJ6XYTUxP6NoQ2Bic9wJbcqPOjHzSPGchI6tQvV";
my $query = "";
my $state;
my $salt;
my $real_pw="";
my $submit_file="login.pl";
#========================================================
if($id){
	$query = "SELECT ui_timeStamp FROM userinfo WHERE ui_id = \'$id\'";
	$state=$con->prepare($query);
	$state->execute();
	my @row = $state->fetchrow_array;
	$salt= $row[0];
	$query = "SELECT ui_pw FROM userinfo WHERE ui_id = \'$id\'";
	$state=$con->prepare($query);
	$state->execute();
	@row = $state->fetchrow_array;
	$real_pw=$row[0];
	$con->disconnect(); 
	$submit_file="set_cookie.pl";
}else{
	$salt_temp=parsegm gmstamp."";
	$salt="";
	$con->disconnect();	
}
#------------------------------------end database-------------------------------
print $q->header(-charset=>"UTF-8");
print <<EOF
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/signup.css" />
	<script src="javascript/AesUtil.js"></script>
	<script src="javascript/aes.js"></script>
	<script src="javascript/pbkdf2.js"></script>
	<script src="javascript/login.js" type="text/javascript"></script>
EOF
;
if($id){
	print "
	<script>
		var aesUtil = new AesUtil(192, 500);
		var dec = aesUtil.decrypt(\"$salt_temp\", \"$iv\", \"$passPhrase\", \"$pw\");
		var aesUtil2 = new AesUtil(256, 1000);
		var enc = aesUtil2.encrypt(\"$salt\", \"$iv\", \"$passPhrase\", dec);
		if(enc==\"$real_pw\"){
			global=setInterval(function(){loginComplete()},500);
		}else{
			alert(\"login fail\");
			window.location=\"login.pl\";
		}
	</script>";
}

print <<EOF
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body>
EOF
;
print <<EOF
	<form id="loginForm" action="$submit_file" method="post" ENCTYPE="multipart/form-data">
		<div class="container">
			<div class="outer">
				<div class="inner">
					<div class="centered_inner_left">
						<p class="leftP">Your ID</p>
						<p class="leftP">Your Password</p>
					</div>
					<section class="webdesigntuts-workshop">
					<input type="hidden" id="IV"  value="$iv"></input>
					<input type="hidden" id="SALT" name="SALT" value="$salt"></input>
					<input type="hidden" id="SALT_TEMP" name="SALT_TEMP" value="$salt_temp"></input>
					<input type="hidden" id="PASSPHRASE"  value="$passPhrase"></input>
					<input type="hidden" id="EPW" name="EPW" value=""></input>
					<input type="text" id="ID" value="$id" autocomplete="off" name="ID" placeholder="ID" onkeyup="id_keyup()" onblur="id_keyup()" maxlength="64"></input>	
					<input type="password" id="PW" autocomplete="off" name="PW" placeholder="PW" maxlength="64"></input>
					<input type="submit" value="Log In" onclick="return CheckSubmit()"></input>
	</form>
					<form action="signup.pl" >
						<input type="submit" value="Sign Up" style="position:relative;left:-20px;top:-100px">
					</form>
					</section>
				</div>
			</div>
		</div>
	</form>
EOF
;
print"</body></html>";

