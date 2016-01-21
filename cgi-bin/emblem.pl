#!/usr/bin/perl
#
#	@Project : Helios
#	@Architecture : KimBom
#	emblem.pl
#
#	@Created by On 2016. 01. 21...
#	@Copyright (C) 2016 KimBom. All rights reserved.
#
use DBI;
require 'css_helper.pl';
require 'login/info.pl';
my $dot_emblem =
  PrintBigDot( "0", "0", "0", "70" ) . PrintSmallDot( "0", "0", "0", "70" );

# @name PrintEmblemBox
# @param1 : emblem name array
sub PrintEmblemBox($) {
	my @emblem_image = @{ $_[0] };
	my $ret          = "";
	my $string       = '<div class= "user_state_3" "style=display:XXXXX">
         		<div class= "user_state_3_1">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_2">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_3">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_4">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_5">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_6">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_7">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_8">
         			$dot_emblem
         			YYYYY
         		</div>
         		<div class= "user_state_3_9">
         			$dot_emblem
         			YYYYY
         		</div>
         	</div>';
	my $block = $string;
	$block =~ s/XXXXX/block/g;
	for ( my $i = 0 ; $i <= $#emblem_image && $i < 9 ; $i++ ) {
		my $tmp =
		  "<img src=\"$emblem_image[$i]\"  width=\"70px\" height=\"70px\">";
		$block =~ s/YYYYY/$tmp/;
	}
	$block =~ s/YYYYY//g;
	$ret = $ret . $block;

	#this is hidden block
	for ( my $i = 9 ; $i <= $#emblem_image ; $i++ ) {	
		$block = $string;
		$block =~ s/XXXXX/none/g;
		for(my $j=$i+9 ; $i < $j && $i<= $#emblem_image;$i++){
			my $tmp ="<img src=\"$emblem_image[$i]\"  width=\"70px\" height=\"70px\">";
			$block =~ s/YYYYY/$tmp/;
		}
		$block =~ s/YYYYY//g;
		$ret = $ret . $block;
	}

	print $ret;
}
my @emblem_image;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $query = "SELECT eb_path FROM userinfo_emblem,emblem 
			WHERE ui_id=\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\' and userinfo_emblem.eb_name=emblem.eb_name";
my $state = $con->prepare($query);
$state->execute();
while ( my @arr = $state->fetchrow_array ) {
	push @emblem_image, $arr[0];
}
@emblem_image=sort @emblem_image;
print @emblem_image;
PrintEmblemBox( \@emblem_image );

$con->disconnect;
1;
