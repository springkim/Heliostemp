#!/usr/bin/perl
#
#	@Project  : Helios
#	@Architecture : Kim Bom
#	set_cookie.pl
#
#	@Created by KimBom On 2016. 1. 3...
#	@Copyright (C) 2015 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
require 'aes.pl';
my $q=new CGI;
my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
chop($enc_name);
chop($enc_name);
chop($enc_name);
my $id=$q->param("HID");
my $enc_id="";
if($id){
	$enc_id=AES_Encrypt($id);
	
}
my $c=$q->cookie(-name=>$enc_name,-value=>$enc_id);

print $q->header(-cookie=>$c);
print <<EOF
<html>
	<head>
		<title>BlueCandle</title>
		<script>
			//window.location="../index.pl";
		</script>
	</head>
	<body>
		<p>$enc_id</p>
		<p>$enc_name</p>
	</body>
</html>
EOF
;
