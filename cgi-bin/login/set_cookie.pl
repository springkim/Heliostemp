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
use Digest::SHA3 qw(sha3_512_hex);
my $q=new CGI;
my $enc_name=sha3_512_hex("bluecandle_helios_cookie_id");
my $id=$q->param("ID");
my $enc_id="";
if($id){
	$enc_id=sha3_512_hex($id);
}
my $c=$q->cookie(-name=>$enc_name,-value=>$enc_id);

print $q->header(-cookie=>$c);
print <<EOF
<html>
	<head>
		<title>BlueCandle</title>
		<script>
			window.location="../index.pl";
		</script>
	</head>
	<body>
	</body>
</html>
EOF
;
