function Equalizer1(){
	var bars = document.getElementsByClassName('bar1');
	[].forEach.call(bars, function (bar) {
	   bar.style.height = Math.random() * 100 + '%';
	});
}
function Equalizer2(){
	var bars = document.getElementsByClassName('bar2');
	[].forEach.call(bars, function (bar) {
	   bar.style.height = Math.random() * 100 + '%';
	});
}
function Equalizer3(){
	var bars = document.getElementsByClassName('bar3');
	[].forEach.call(bars, function (bar) {
	   bar.style.height = Math.random() * 100 + '%';
	});
}
var song_status=0;
var e1,e2,e3;
function SongBtn(){
	if(song_status==1){
		document.getElementById("songaudio").pause();
		song_status=0;
		clearTimeout(e1);
		clearTimeout(e2);
		clearTimeout(e3);
	}else{
		document.getElementById("songaudio").play();
		song_status=1;
		e1 = setInterval(function(){Equalizer1()},200);
		e2 = setInterval(function(){Equalizer2()},300);
		e3 = setInterval(function(){Equalizer3()},400);
	}
}
//======================================================================
function startClock() { // internal clock//
	var today=new Date();
	var h=today.getHours();
	var m=today.getMinutes();
	var s=today.getSeconds();
	m = checkTime(m);
	s = checkTime(s);
	var time=h+":"+m+":"+s;
	document.getElementById('clock').innerHTML = time;
	var t = setTimeout(function(){startClock()},500);
	
}
function checkTime(i) {
if (i<10) {i = "0" + i};  // add zero in front of numbers < 10 
	return i;
}
function checkDate(i) {
 	i = i+1 ;  // to adjust real month
   	return i;
}